;;==============================================================================

;;; File: "_t-cpu-primitives.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Constants

(define is-load-store-arch #f)

(define na (x86-cl))  ;; number of arguments register
(define sp (x86-rsp)) ;; Real stack limit
(define fp (x86-rdx)) ;; Simulated stack current pos
(define dp (x86-rcx)) ;; Thread descriptor register
(define runtime-result-register (x86-rax))

(define stack-size 10000) ;; Scheme stack size (bytes)
;; 500 is the safe minimum for (fib 40)
(define thread-descriptor-size 32) ;; Thread descriptor size (bytes)
(define stack-underflow-padding 128) ;; Prevent underflow from writing thread descriptor (bytes)
(define frame-offset 1) ;; stack offset so that frame[1] is at null offset from fp

;; 64 = 01000000_2 = 0x40. -64 = 11000000_2 = 0xC0
;; 0xC0 unsigned = 192
(define na-reg-default-value -64)
(define na-reg-default-value-abs 192)

;;------------------------------------------------------------------------------

;; Primitives

(define x86-prim-fx+
  (arithmetic-prim x86-add '(number) (default-arithmetic-allowed-opnds is-load-store-arch) #t))

(define x86-prim-fx-
  (arithmetic-prim x86-sub '(number) (default-arithmetic-allowed-opnds is-load-store-arch) #f))

(define x86-prim-fx<
  (arithmetic-prim x86-cmp (list 'boolean x86-jle x86-jg) (default-arithmetic-allowed-opnds is-load-store-arch) #f))

(define primitive-object-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##fx+ (make-prim-obj x86-prim-fx+ 2 #t #f))
    (table-set! table '##fx- (make-prim-obj x86-prim-fx- 2 #t #f))
    (table-set! table '##fx< (make-prim-obj x86-prim-fx< 2 #t #t))
    ; (table-set! '##fx>  (list x86-prim-fx+ 2 #t #t))
    table))

;;------------------------------------------------------------------------------

;; Thread descriptor table

(define thread-descriptor-table
  (let ((table (make-table test: equal?)))
    (table-set! table 'underflow-position (x86-rax))
    (table-set! table 'interrupt-flag     (x86-rax))
    (table-set! table 'narg               (x86-rax))

    table))

;;                             x86 64 bits backend

(define (x86-64-abstract-machine-info) (make-backend (info) (operands) (instructions) (routines)))

;;------------------------------------------------------------------------------

;; Backend info

(define (info)
  (make-backend-info
    8                         ;; Word width
    'le                       ;; Endianness
    is-load-store             ;; Load store architecture?
    fp                        ;; Stack pointer register
    frame-offset              ;; Frame offset
    thread-descriptor-table   ;; Thread descriptor table
    primitive-object-table    ;; Primitive table
    (vector                   ;; Main registers
      (x86-r15) (x86-r14) (x86-r13) (x86-r12) (x86-r11))
    (vector)                  ;; Spill registers
    (vector                   ;; Extra registers
      (x86-r10) (x86-r9) (x86-r8))
    make-cgc                  ;; CGC constructor
    ))

(define (make-cgc)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (x86-arch-set! cgc 'x86-64)
    cgc))

;;------------------------------------------------------------------------------

;; Backend operands

(define (operands)
  (make-operand-dictionnary
    x86-imm-int
    (lambda (x) (and (pair? x) (number? (cdr x))))
    x86-imm-lbl
    (lambda (x) (and (pair? x) (vector? (cdr x))))
    x86-mem
    (lambda (x) (and (vector? x) (fx= (vector-length x) 4)))
    fixnum?                       ;; reg?
    (lambda (x) (cdr x))          ;; int-opnd-value
    (lambda (x) (car x))          ;; lbl-opnd-offset
    (lambda (x) (cdr x))          ;; lbl-opnd-label
    (lambda (x) (vector-ref x 0)) ;; mem-opnd-offset
    (lambda (x) (vector-ref x 1)) ;; mem-opnd-reg
    ))

;;------------------------------------------------------------------------------

(define (instructions)
  (make-instruction-dictionnary
    x86-label-align ;; am-lbl
    data-instr      ;; am-data
    mov-instr       ;; am-mov.
    x86-lea         ;; am-load-mem-address
    x86-add         ;; am-add
    x86-sub         ;; am-sub
    x86-shr         ;; am-bit-shift-right
    x86-shl         ;; am-bit-shift-left
    x86-not         ;; am-not
    x86-and         ;; am-and
    x86-or          ;; am-or
    x86-xor         ;; am-xor
    x86-jmp         ;; am-jmp
    cmp-jump-instr  ;; am-compare-jump
    ))

(define (x86-label-align cgc label #!optional (align #f))
  (if align
    (asm-align cgc (car align) (cdr align) #x90))
    (x86-label cgc label))

(define data-instr
  (make-am-data x86-db x86-dw x86-dd x86-dq))

(define (mov-instr cgc dst src #!optional (width #f))
  (if (lbl-opnd? cgc dst)
    (let ((extra-reg (get-extra-register cgc 0)))
      (x86-mov cgc extra-reg dst)
      (x86-mov cgc (x86-mem 0 extra-reg) src))
    (x86-mov cgc dst src width)))

(define (cmp-jump-instr cgc opnd1 opnd2 condition loc-true loc-false)
  (define (flip pair)
      (cons (cdr pair) (car pair)))

  (define (get-jumps condition)
    (case (get-condition condition)
            ((equal)
              (cons x86-je  x86-jne))
            ((greater)
              (cond
                ((and (cond-is-equal condition) (cond-is-signed condition))
                  (cons x86-jge x86-jl))
                ((and (not (cond-is-equal condition)) (cond-is-signed condition))
                  (cons x86-jg x86-jle))
                ((and (cond-is-equal condition) (not (cond-is-signed condition)))
                  (cons x86-jae x86-jb))
                ((and (not (cond-is-equal condition)) (not (cond-is-signed condition)))
                  (cons x86-ja x86-jbe))))
            ((not-equal) (flip (get-jumps (inverse-condition condition))))
            ((not-greater) (flip (get-jumps (inverse-condition condition))))
            (else
              (compiler-internal-error "cmp-jump-instr - Unknown condition: " condition))))

  (display "cmp-jump-instr")
  (let* ((jumps (get-jumps condition)))

    ;; In case both jump locations are false, the cmp is unnecessary.
    (if (or loc-true loc-false)
      (x86-cmp cgc opnd1 opnd2))

    (cond
      ((and loc-false loc-true)
        ((car jumps) cgc loc-true)
        (x86-jmp cgc loc-false))
      ((and (not loc-true) loc-false)
        ((cdr jumps) cgc loc-false))
      ((and loc-true (not loc-false))
        ((car jumps) cgc loc-true))
      (else
        (debug "am-compare-jump: No jump encoded")))))

;;------------------------------------------------------------------------------

;; Backend routines

(define (routines)
  (make-routine-dictionnary
    x64-poll
    default-set-narg
    default-check-narg
    x64-init-routine
    x64-end-routine
    x64-error-routine
    x64-place-extra-data
    ))

(define (x64-poll cgc code)
  ;; Reminder: sp is the real stack pointer and fp is the simulated stack pointer
  ;; In memory
  ;; +++: underflow location
  ;; ++ : fp
  ;; +  : sp
  ;; 0  : Overflow
  ;; sp < fp < underflow
  (define (check-overflow)
    (debug "check-overflow\n")
    (let ((condition (condition-greater #f #f))
          (error-lbl (get-other-label cgc 'OVERFLOW_LBL)))
      (am-compare-jump cgc fp sp condition error-lbl #f)))
  (define (check-underflow)
    (debug "check-underflow\n")
    (let ((opnd (get-thread-descriptor-opnd cgc 'underflow-position))
          (condition (condition-not-greater #f #f))
          (error-lbl (get-other-label cgc 'UNDERFLOW_LBL)))
      (am-compare-jump cgc opnd fp condition error-lbl #f)))

  (define (check-interrupt)
    (debug "check-interrupt\n")
    (let ((opnd (get-thread-descriptor-opnd cgc 'interrupt-flag))
          (condition condition-not-equal)
          (error-lbl (get-other-label cgc 'INTERRUPT_LBL)))
      (am-compare-jump cgc opnd (int-opnd cgc 0) condition error-lbl #f)))

  (make-poll check-interrupt check-underflow check-overflow))

;; Start routine
;; Gets executed before main
(define (x64-init-routine cgc)
  (debug "put-init-routine\n")

  (am-lbl cgc (get-other-label cgc 'C_START_LBL)) ;; Initial procedure label
  ;; Thread descriptor initialization
  ;; Set thread descriptor address
  (am-mov cgc dp (lbl-opnd cgc (get-other-label cgc 'THREAD_DESCRIPTOR)))
  ;; Set lower bytes of descriptor register used for passing narg
  (am-mov cgc na (int-opnd cgc na-reg-default-value (get-word-width-bits cgc)))
  ;; Set underflow position to current stack pointer position
  (am-mov cgc (get-thread-descriptor-opnd cgc 'underflow-position) sp)
  ;; Set interrupt flag to current stack pointer position
  (am-mov cgc (get-thread-descriptor-opnd cgc 'interrupt-flag) (int-opnd cgc 0) (get-word-width-bits cgc))

  (am-mov cgc (get-register cgc 0) (lbl-opnd cgc (get-other-label cgc 'C_RETURN_LBL))) ;; Set return address for main
  (am-load-mem-address cgc fp (mem-opnd cgc (* frame-offset (- (get-word-width cgc))) sp)) ;; Align frame with offset
  (am-sub cgc sp (int-opnd cgc stack-size)))

;; End routine
;; Gets executed after main if no error happened during execution
(define (x64-end-routine cgc)
  (debug "put-end-routine\n")

  ;; Terminal procedure
  (am-lbl cgc (get-other-label cgc 'C_RETURN_LBL))
  (am-add cgc sp (int-opnd cgc stack-size))
  (am-mov cgc runtime-result-register (get-register cgc 1))
  (x86-ret cgc)) ;; Exit program

;; Error routine
;; Gets executed if an error occurs
(define (x64-error-routine cgc)
  (debug "put-error-routine\n")

  (am-lbl cgc (get-other-label cgc 'WRONG_NARGS_LBL)) ;; Incorrect narg handling
  (am-lbl cgc (get-other-label cgc 'OVERFLOW_LBL))    ;; Overflow handling
  (am-lbl cgc (get-other-label cgc 'UNDERFLOW_LBL))   ;; Underflow handling
  (am-lbl cgc (get-other-label cgc 'INTERRUPT_LBL))   ;; Interrupts handling
  (am-lbl cgc (get-other-label cgc 'TYPE_ERROR_LBL))  ;; Type error handling

  (am-mov cgc fp (get-thread-descriptor-opnd cgc 'underflow-position)) ;; Pop stack

  ;; Pop remaining stack (Everything allocated but stack size)
  (am-add cgc sp (int-opnd cgc stack-size))
  (am-mov cgc runtime-result-register (int-opnd cgc -4))
  (x86-ret cgc 0))

(define (x64-place-extra-data cgc)
  (debug "place-extra-data\n")
  (am-lbl cgc (get-other-label cgc 'THREAD_DESCRIPTOR) (cons 256 1))
  (reserve-space cgc thread-descriptor-size 0))
