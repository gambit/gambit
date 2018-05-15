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

(define narg-pointer (x86-cl))  ;; number of arguments register
(define stack-pointer (x86-rsp)) ;; Real stack limit
(define frame-pointer (x86-rdx)) ;; Simulated stack current pos

(define stack-size 10000) ;; Scheme stack size (bytes)
;; 500 is the safe minimum for (fib 40)
(define thread-descriptor-size 32) ;; Thread descriptor size (bytes)
(define stack-underflow-padding 128) ;; Prevent underflow from writing thread descriptor (bytes)
(define frame-offset 1) ;; stack offset so that frame[1] is at null offset from frame-pointer

;; 64 = 01000000_2 = 0x40. -64 = 11000000_2 = 0xC0
;; 0xC0 unsigned = 192
(define na-reg-default-value -64)
(define na-reg-default-value-abs 192)

(define (THREAD_DESCRIPTOR_LBL cgc) (get-label cgc 'THREAD_DESCRIPTOR_LBL))
(define (C_START_LBL cgc)           (get-label cgc 'C_START_LBL))
(define (C_RETURN_LBL cgc)          (get-label cgc 'C_RETURN_LBL))
(define (WRONG_NARGS_LBL cgc)       (get-label cgc 'WRONG_NARGS_LBL))
(define (OVERFLOW_LBL cgc)          (get-label cgc 'OVERFLOW_LBL))
(define (UNDERFLOW_LBL cgc)         (get-label cgc 'UNDERFLOW_LBL))
(define (INTERRUPT_LBL cgc)         (get-label cgc 'INTERRUPT_LBL))
(define (TYPE_ERROR_LBL cgc)        (get-label cgc 'TYPE_ERROR_LBL))

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

(define (get-thread-descriptor-opnd cgc sym)
  (let ((label (THREAD_DESCRIPTOR_LBL cgc)))
    (case sym
      ((underflow-position) (x86-imm-lbl label 0))
      ((interrupt-flag)     (x86-imm-lbl label 8))
      ((narg)               (x86-imm-lbl label 16))
      (else (compiler-internal-error "Unknown thread descriptor field: " sym)))))


;;                             x86 64 bits backend

(define (x86-64-abstract-machine-info) (make-backend (info) (operands) (instructions) (routines)))

;;------------------------------------------------------------------------------

;; Backend info

(define (info)
  (make-backend-info
    8                         ;; Word width
    'le                       ;; Endianness
    is-load-store-arch        ;; Load store architecture?
    frame-pointer             ;; Stack pointer register
    frame-offset              ;; Frame offset
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
    mov-instr       ;; am-mov
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
      (x86-mov cgc (x86-mem 0 extra-reg) src width))
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
    x64-set-narg
    x64-check-narg
    x64-init-routine
    x64-end-routine
    x64-error-routine
    x64-place-extra-data
    ))

(define (x64-poll cgc code)
  ;; Reminder: stack-pointer is the real stack pointer and frame-pointer is the simulated stack pointer
  ;; stack-pointer {overflow pos} < frame-pointer < {underflow pos}
  (define (check-overflow)
    (debug "check-overflow")
    (let ((condition (condition-greater #f #f))
          (error-lbl (OVERFLOW_LBL cgc)))
      (am-compare-jump cgc frame-pointer stack-pointer condition error-lbl #f)))
  (define (check-underflow)
    (debug "check-underflow")
    (let ((opnd (get-thread-descriptor-opnd cgc 'underflow-position))
          (condition (condition-not-greater #f #f))
          (error-lbl (UNDERFLOW_LBL cgc)))
      (am-compare-jump cgc opnd frame-pointer condition error-lbl #f)))

  (define (check-interrupt)
    (debug "check-interrupt")
    (let ((opnd (get-thread-descriptor-opnd cgc 'interrupt-flag))
          (condition condition-not-equal)
          (error-lbl (INTERRUPT_LBL cgc)))
      (am-compare-jump cgc opnd (int-opnd cgc 0) condition error-lbl #f)))

  (make-poll check-interrupt check-underflow check-overflow))

(define (make-parity-adjusted-valued n)
  (define (bit-count n)
    (if (= n 0)
      0
      (+ (modulo n 2) (bit-count (quotient n 2)))))
  (let* ((narg2 (* 2 (- n 3)))
        (bits (bit-count narg2))
        (parity (modulo bits 2)))
    (+ 64 parity narg2)))

(define (x64-set-narg cgc narg)
    (debug "x64-set-narg: " narg "\n")
    (cond
      ((= narg 0)
        (x86-cmp cgc narg-pointer narg-pointer))
      ((= narg 1)
        (x86-cmp cgc narg-pointer (int-opnd cgc -65)))
      ((= narg 2)
        (x86-cmp cgc narg-pointer (int-opnd cgc 66)))
      ((= narg 3)
        (x86-cmp cgc narg-pointer (int-opnd cgc 0)))
      ((<= narg 34)
        (x86-add cgc narg-pointer (int-opnd cgc (make-parity-adjusted-valued narg))))
      (else
        (default-set-narg cgc narg))))

(define (x64-check-narg cgc narg)
  (debug "x64-check-narg: " narg "\n")
  (let ((error-lbl (WRONG_NARGS_LBL cgc)))
    (cond
      ((= narg 0)
        (x86-jne cgc error-lbl))
      ((= narg 1)
        (x86-jp cgc error-lbl))
      ((= narg 2)
        (x86-jno cgc error-lbl))
      ((= narg 3)
        (x86-jns cgc error-lbl))
      ((<= narg 34)
        (x86-sub cgc narg-pointer (int-opnd cgc (make-parity-adjusted-valued narg)))
        (x86-jne cgc error-lbl))
      (else
        (default-check-narg cgc narg error-lbl)))))

;; Start routine
;; Gets executed before main
(define (x64-init-routine cgc)
  (debug "put-init-routine")

  (am-lbl cgc (C_START_LBL cgc)) ;; Initial procedure label
  ;; Set lower bytes of descriptor register used for passing narg
  (am-mov cgc narg-pointer (int-opnd cgc na-reg-default-value (get-word-width-bits cgc)))
  ;; Set underflow position to current stack pointer position
  (am-mov cgc (get-thread-descriptor-opnd cgc 'underflow-position) stack-pointer)
  ;; Set interrupt flag to current stack pointer position
  (am-mov cgc
    (get-thread-descriptor-opnd cgc 'interrupt-flag)
    (int-opnd cgc 0)
    (get-word-width-bits cgc))

  ;; Set return address for main
  (am-mov cgc
    (get-register cgc 0)
    (lbl-opnd cgc (C_RETURN_LBL cgc)))

  ;; Align frame with offset
  (am-load-mem-address cgc
    frame-pointer
    (mem-opnd cgc (* frame-offset (- (get-word-width cgc))) stack-pointer))

  ;; Allocate stack
  (am-sub cgc stack-pointer (int-opnd cgc stack-size)))

;; End routine
;; Gets executed after main if no error happened during execution
(define (x64-end-routine cgc)
  (debug "put-end-routine")

  ;; Terminal procedure
  (am-lbl cgc (C_RETURN_LBL cgc))
  (am-add cgc stack-pointer (int-opnd cgc stack-size))
  (am-mov cgc (x86-rax) (get-register cgc 1))
  (x86-ret cgc)) ;; Exit program

;; Error routine
;; Gets executed if an error occurs
(define (x64-error-routine cgc)
  (debug "put-error-routine")

  (am-lbl cgc (WRONG_NARGS_LBL cgc)) ;; Incorrect narg handling
  (am-lbl cgc (OVERFLOW_LBL cgc))    ;; Overflow handling
  (am-lbl cgc (UNDERFLOW_LBL cgc))   ;; Underflow handling
  (am-lbl cgc (INTERRUPT_LBL cgc))   ;; Interrupts handling
  (am-lbl cgc (TYPE_ERROR_LBL cgc))  ;; Type error handling

  (am-mov cgc frame-pointer (get-thread-descriptor-opnd cgc 'underflow-position)) ;; Pop stack

  ;; Pop remaining stack (Everything allocated but stack size)
  (am-add cgc stack-pointer (int-opnd cgc stack-size))
  (am-mov cgc (x86-rax) (int-opnd cgc -4))
  (x86-ret cgc 0))

(define (x64-place-extra-data cgc)
  (debug "place-extra-data")
  (am-lbl cgc (THREAD_DESCRIPTOR_LBL cgc) (cons 256 0))
  (reserve-space cgc thread-descriptor-size 0))
