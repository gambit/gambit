;;==============================================================================

;;; File: "_t-cpu-primitives.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

;;              x86 64 bits backend

;;  Backend definition:
;;  Bindings for the abstract machine instructions
;;  Primitive table
;;  Init/End/Error handling routine

;; Finishes creation of CGC and initialize instruction encoder
;; Leave #f as NOP
(define (x64-setup cgc)
  (asm-init-code-block cgc 0 'le)
  (x86-arch-set! cgc 'x86-64))

;; Resets state of instruction encoder if necessary.
;; Leave #f as NOP
(define (x64-cleanup) #f)

;; Hash table
;; Key:   Primitive's name (symbol)
;; Value: Primitive's function (as defined in _t-cpu-primitives.scm)
(define (x64-primitive-table)
  (debug "Creating table\n")
  (let ((table (make-table test: eqv?)))
    (table-set! table '##fx+      (x86-prim-fx+))
    (table-set! table '##fx-      (x86-prim-fx-))
    (table-set! table '##fx<      (x86-prim-fx<))
    (table-set! table '##fixnum?  (x86-prim-fixnum?))
    (table-set! table '##pair?    (x86-prim-pair?))
    (table-set! table '##boolean? (x86-prim-boolean?))
    (table-set! table '##string?  (x86-prim-string?))
    ; ('length (x86-prim-string-length))
    ; ('##fx*         (x86-prim-fx<))
    ; ('##fx/         (x86-prim-fx<))
    ; ('display (prim-info-display))
    table))

(define (x86-prim-fx+)
  (arithmetic-prim am-add 'number (default-arithmetic-allowed-opnds) #t))

(define (x86-prim-fx-)
  (arithmetic-prim am-sub 'number (default-arithmetic-allowed-opnds) #f))

(define (x86-prim-fx<)
  (arithmetic-prim am-cmp (list 'boolean x86-jle x86-jg) (default-arithmetic-allowed-opnds) #f))

(define (x86-prim-fixnum?)
  (type-check-primitive fixnum-obj-desc))

(define (x86-prim-string?)
  (type-check-primitive string-obj-desc))

(define (x86-prim-pair?)
  (type-check-primitive pair-obj-desc))

(define (x86-prim-boolean?)
  (type-check-primitive boolean-obj-desc))

;; Sets functions defined for abstract machine
;; See _t-cpu-abstract-machine.scm for variables to set!
(define (x64-setup-abstract-machine)
  (define (register-setup)
    (set! main-registers
      (list (x86-r15) (x86-r14) (x86-r13) (x86-r12) (x86-r11) (x86-r10)))
    (set! work-registers
      (list (x86-r9) (x86-r8)))
    (set! na (x86-cl))
    (set! sp (x86-rsp))
    (set! fp (x86-rdx))
    (set! dp (x86-rcx))
    (set! runtime-result-register (x86-rax)))

  (define (opnds-setup)
    (set! int-opnd x86-imm-int)
    (set! lbl-opnd x86-imm-lbl)
    (set! mem-opnd x86-mem)

    ;; Copied from _x86.scm
    (set! int-opnd? (lambda (x) (and (pair? x) (number? (cdr x)))))
    (set! lbl-opnd? (lambda (x) (and (pair? x) (vector? (cdr x)))))
    (set! mem-opnd? (lambda (x) (and (vector? x) (fx= (vector-length x) 4))))
    (set! reg-opnd? fixnum?)

    (set! int-opnd-value  (lambda (x) (cdr x)))
    (set! lbl-opnd-offset (lambda (x) (car x)))
    (set! lbl-opnd-label  (lambda (x) (cdr x)))
    (set! mem-opnd-offset (lambda (x) (vector-ref x 0)))
    (set! mem-opnd-reg    (lambda (x) (vector-ref x 1))))

  (define (instructions-setup)
    (set! am-lbl x86-label)
    (set! am-mov
      (wrap-function x86-mov
        (list
          (make-rule
            "mov R 0 -> xor R R"
            (all-rules (match-reg 1 #f) (match-int 2 0))
            x86-xor
            (reorganize-args '(0 1 1))))))
    (set! am-lda x86-lea)
    (set! am-ret x86-ret)
    (set! am-cmp x86-cmp)

    (set! am-bit-shift-right x86-shr)
    (set! am-bit-shift-left  x86-shl)

    (set! am-not x86-not)
    (set! am-and x86-and)
    (set! am-or  x86-or)
    (set! am-xor x86-xor)
    (set! am-test x86-test)

    (set! am-add
      (wrap-function x86-add
        (list
          (make-rule "add _ 0 -> nop" (match-int 2 0) NOP)
          (make-rule "add _ 1 -> inc _" (match-int 2 1) x86-inc (reorganize-args '(0 1))))))
    (set! am-sub x86-sub)

    (set! am-jmp    x86-jmp)
    ; (set! am-jmplink  doesnt-exist)
    (set! am-je     x86-je)
    (set! am-jne    x86-jne)
    (set! am-jg     x86-jg)
    (set! am-jng    x86-jle)
    (set! am-jge    x86-jge)
    (set! am-jnge   x86-jl)
    (set! am-jgu    x86-ja)
    (set! am-jngu   x86-jbe)
    (set! am-jgeu   x86-jae)
    (set! am-jngeu  x86-jb))

  (define (data-setup)
    (set! am-db x86-db)
    (set! am-dw x86-dw)
    (set! am-dd x86-dd)
    (set! am-dq x86-dq))

  (define (helper-setup)
    (set! am-set-narg   x64-set-narg)
    (set! am-check-narg x64-check-narg)
    (set! am-poll default-poll)
    (set! make-opnd default-make-opnd)
  )

  (define (make-parity-adjusted-valued n)
    (define (bit-count n)
      (if (= n 0)
        0
        (+ (modulo n 2) (bit-count (quotient n 2)))))
    (let* ((narg2 (* 2 (- n 3)))
          (bits (bit-count narg2))
          (parity (modulo bits 2)))
      (+ 64 parity narg2)))

  (define (x64-check-narg cgc narg)
    (debug "x64-check-narg: " narg "\n")
    (cond
      ((= narg 0)
        (am-jne cgc WRONG_NARGS_LBL))
      ((= narg 1)
        (x86-jp cgc WRONG_NARGS_LBL))
      ((= narg 2)
        (x86-jno cgc WRONG_NARGS_LBL))
      ((= narg 3)
        (x86-jns cgc WRONG_NARGS_LBL))
      ((<= narg 34)
          (am-sub cgc na (int-opnd (make-parity-adjusted-valued narg)))
          (am-jne cgc WRONG_NARGS_LBL))
      (else
        (default-check-narg cgc narg))))

  (define (x64-set-narg cgc narg)
    (debug "x64-set-narg: " narg "\n")
    (cond
      ((= narg 0)
        (am-cmp cgc na na))
      ((= narg 1)
        (am-cmp cgc na (int-opnd -65)))
      ((= narg 2)
        (am-cmp cgc na (int-opnd 66)))
      ((= narg 3)
        (am-cmp cgc na (int-opnd 0)))
      ((<= narg 34)
          (am-add cgc na (int-opnd (make-parity-adjusted-valued narg))))
      (else
        (default-set-narg cgc narg))))

  (set! word-width 64)
  (set! word-width-bytes 8)
  (set! endianness 'le)
  (set! load-store-only #f)
  (set! enable-poll #t)

  (register-setup)
  (opnds-setup)
  (instructions-setup)
  (data-setup)
  (helper-setup))

;; Start routine
;; Gets executed before main
(define (x64-init-routine cgc)
  (debug "put-init-routine\n")

  (am-lbl cgc C_START_LBL) ;; Initial procedure label
  ;; Thread descriptor initialization
  ;; Set thread descriptor address
  (am-mov cgc dp (lbl-opnd THREAD_DESCRIPTOR))
  ;; Set lower bytes of descriptor register used for passing narg
  (am-mov cgc na (int-opnd na-reg-default-value word-width))
  ;; Set underflow position to current stack pointer position
  (am-mov cgc (thread-descriptor underflow-position-offset) sp)
  ;; Set interrupt flag to current stack pointer position
  (am-mov cgc (thread-descriptor interrupt-offset) (int-opnd 0) word-width)

  (am-mov cgc (get-register 0) (lbl-opnd C_RETURN_LBL)) ;; Set return address for main
  (am-lda cgc fp (mem-opnd (* offs (- word-width-bytes)) sp)) ;; Align frame with offset
  (am-sub cgc sp (int-opnd stack-size)))

;; End routine
;; Gets executed after main if no error happened during execution
(define (x64-end-routine cgc)
  (debug "put-end-routine\n")

  ;; Terminal procedure
  (am-lbl cgc C_RETURN_LBL)
  (am-add cgc sp (int-opnd stack-size))
  (am-mov cgc runtime-result-register (get-register 1))
  (am-ret cgc)) ;; Exit program

;; Error routine
;; Gets executed if an error occurs
(define (x64-error-routine cgc)
  (debug "put-end-routine\n")

  (am-lbl cgc WRONG_NARGS_LBL) ;; Incorrect narg handling
  (am-lbl cgc OVERFLOW_LBL)    ;; Overflow handling
  (am-lbl cgc UNDERFLOW_LBL)   ;; Underflow handling
  (am-lbl cgc INTERRUPT_LBL)   ;; Interrupts handling
  (am-lbl cgc TYPE_ERROR_LBL)  ;; Type error handling

  (am-mov cgc fp (thread-descriptor underflow-position-offset)) ;; Pop stack

  ;; Pop remaining stack (Everything allocated but stack size)
  (am-add cgc sp (int-opnd stack-size))
  (am-mov cgc runtime-result-register (int-opnd -4))
  (am-ret cgc 0))

;; Place data used by start, end and error routines
(define (x64-place-data cgc) #f)