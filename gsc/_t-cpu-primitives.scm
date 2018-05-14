;;==============================================================================

;;; File: "_t-cpu-primitives.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

(define (make-prim-obj fun arity inlinable testable)
  (vector 'prim fun arity inlinable testable))
(define (get-primitive-function prim-object)  (vector-ref prim-object 1))
(define (get-primitive-arity prim-object)     (vector-ref prim-object 2))
(define (get-primitive-inlinable prim-object) (vector-ref prim-object 3))
(define (get-primitive-testable prim-object)  (vector-ref prim-object 4))

;;  A primitive is a function taking:
;;  CGC
;;  ResultAction
;;  Arguments
;;    ResultAction = Copy location-opnd | Branch true-jump-location false-jump-location | Return

(define (then-jump true-location false-location) (list 'jump true-location false-location))
(define (then-jump? then) (eqv? 'jump (car then)))
(define (then-jump-true-location then) (cadr then))
(define (then-jump-false-location then) (caddr then))

(define (then-move  store-location) (cons 'mov store-location))
(define (then-move? then) (eqv? 'mov (car then)))
(define (then-move-store-location then) (cdr then))

(define (then-return) '(return))
(define (then-return? then) (eqv? 'return (car then)))

;;  Most primitives can be split in 3 parts:
;;    Prologue:
;;      Function setup
;;      Can be useful to optimize arguments order or load operands that can't
;;      be used as is by the function,
;;
;;    Useful function:
;;      Usually a simple call to am-instr
;;
;;    Epilogue:
;;      Extract result from function and place it where it should be.
;;      Put back stuff changed by primitive (e.g. pop registers that may have spilled)
(define (make-primitive prologue asm-fun epilogue)
  (lambda (cgc result-action args)
    (let* ((prologue-result (prologue cgc result-action args)))
      (asm-fun cgc result-action prologue-result)
      (epilogue cgc result-action prologue-result))))

;; Saves 1 line! Yay
(define (wrap-asm-fun asm-fun)
  (lambda (cgc result-action args)
    (apply asm-fun (cons cgc args))))

;; Apply prologues linearly.
;; Applies the modified arguments returned by the previous prologue into the next
(define (compose-prologues . progs)
  (define (loop prologues)
    (if (null? prologues)
      idlogue
      (lambda (cgc result-action args)
        (let* ((prologue (car prologues))
               (new-args (prologue cgc result-action args)))
          ((loop (cdr prologues)) cgc result-action new-args)))))

  (loop progs))

(define compose-epilogues compose-prologues)

;; Identity prologue/epilogue
(define (idlogue cgc result-action args) args)

;; Prologue for primitives that are commutative.
;; Reduces the number of mov by commuting the operands.
;; Suppose that the result is put in the first argument (like epilogue-use-result-default)
(define prologue-commute
  (lambda (cgc result-action args)
    (debug "prologue-commute")
    (if (then-move? result-action)
      (let ((result-loc-index (index-of (then-move-store-location result-action) args)))
        (if (not (= -1 result-loc-index))
            (swap-index 0 result-loc-index args)
            args))
      args)))

;; Prologue for primitives that may not support some types of operands.
;; This prologue mov every operands not supported in the extra registers.
;; todo :: Do something if need more registers. (Save some less important registers on stack)
(define (prologue-mov-args allowed-opnds)
  (define (mov-arg cgc result-reg index arg)
    (debug "mov-arg")
    (let* ((allowed-opnd (list-ref allowed-opnds index))
           (in? (not (= -1 (index-of (opnd-type cgc arg) allowed-opnd)))))
      (if in?
        arg
          (let ((new-register
                  ;; Check if result-reg can be used as extra register.
                  (if (and (= 0 index) (not (eqv? result-reg #f)))
                    result-reg
                    (get-extra-register cgc index))))
            (am-mov cgc new-register arg)
            new-register))))

  (lambda (cgc result-action args)
    (debug "prologue-mov-args")
    (let* ((store-location (then-move-store-location result-action))
           (result-reg (if (and
                            (then-move? result-action)
                            (reg-opnd? cgc store-location)
                            (= -1 (index-of store-location args)))
                          store-location
                          #f)))
      (map
        (lambda (index arg) (mov-arg cgc result-reg index arg))
        (iota 0 (- (length args) 1))
        args))))

;; Default epilogue for primitives that put their results in their first arguments
;; Ex am-add r1 r2 == r1 <- r1 + r2
(define (epilogue-use-result-default cgc result-action args)
  (debug "epilogue-use-result-default")
    (cond
      ((then-jump? result-action)
        ;; The function doesn't return a boolean => result is always true
        (am-jmp cgc (then-jump-true-location result-action)))
      ((then-move? result-action)
        (let ((result-action-location (then-move-store-location result-action)))
          (if (and (not (null? args))
                (not (equal? result-action-location (car args))))
            (am-mov cgc result-action-location (car args)))))
      ((then-return? result-action)
        (am-jmp cgc (get-register cgc 0)))
      ((not result-action)
        ;; Do nothing
        #f)
      (else
        (compiler-internal-error "epilogue-use-result-default - Unknown result-action" result-action))))

;; Default epilogue for primitives that put their results in flag register
(define (epilogue-use-result-boolean true-test-jump false-test-jump)
  (lambda (cgc result-action args)
  (debug "epilogue-use-result-boolean")
    (cond
      ((then-jump? result-action)
        (let ((true-location  (then-jump-true-location  result-action))
              (false-location (then-jump-false-location result-action)))
          (cond
            ((and true-location false-location)
              (true-test-jump cgc true-location)
              (am-jmp cgc false-location))
            (true-location
              (true-test-jump cgc true-location))
            (false-location
              (false-test-jump cgc false-location)))))

      ((then-move? result-action)
        ;; Extract boolean
        (let* ((suffix "_jump")
               (label (make-unique-label cgc suffix))
               (result-loc (then-move-store-location result-action)))

            (am-mov cgc result-loc (int-opnd (car (format-object boolean-obj-desc #t))))
            (true-test-jump cgc label)
            (am-mov cgc result-loc (int-opnd (car (format-object boolean-obj-desc #f))))
            (am-lbl cgc label)))
      ((then-return? result-action)
        ;; Extract boolean then jump
        (let* ((suffix "_jump")
               (label (make-unique-label cgc suffix))
               (result-loc (get-register 1))
               (return-loc (get-register 0)))

            (am-mov cgc result-loc (int-opnd (car (format-object boolean-obj-desc #t))))
            (true-test-jump cgc label)
            (am-mov cgc result-loc (int-opnd (car (format-object boolean-obj-desc #f))))
            (am-lbl cgc label)
            (am-jmp cgc return-loc)))
      ((not result-action)
        ;; Do nothing
        #f)
      (else
        (compiler-internal-error "epilogue-use-result-boolean - Unknown result-action" result-action)))))

;; ***** Arithmetic primitives

(define (default-arithmetic-allowed-opnds is-load-store)
  (if is-load-store
    '((reg) (reg int))
    '((reg) (reg int mem))))

(define (arithmetic-prim asm-fun return-type allowed-opnds commutative)
  (let ((commutative-prologue (if commutative prologue-commute idlogue)))
    (make-primitive
      (compose-prologues
        commutative-prologue
        (prologue-mov-args allowed-opnds))

      (wrap-asm-fun asm-fun)

      (if (equal? 'boolean (car return-type))
          (apply epilogue-use-result-boolean (cdr return-type))
          epilogue-use-result-default))))

;; ***** Memory read primitives

(define (prim-test cgc)
  (let ((allowed-opnds (if (is-load-store? cgc)
                        '((reg) (reg int))
                        '((reg mem) (reg int)))))
    (make-primitive
      (prologue-mov-args allowed-opnds)
      (wrap-asm-fun am-test)
      (epilogue-use-result-boolean am-je am-jne))))

(define (read-reference cgc dest ref tag offset)
  (let* ((mem-location (get-opnd-with-offset ref (- tag))))
    (am-mov cgc dest mem-location)))

(define (type-check-primitive obj-desc)
  (define (test-pointer-tag cgc result-action opnd obj-desc)
    ;; todo : Test if bit shifting is faster. Probably not, but may be interesting
    (let ((cmp-opnd (int-opnd (flip-bits (get-desc-pointer-tag obj-desc) tag-width))))
      ((prim-test cgc) cgc result-action (list opnd cmp-opnd))))

  (cond
    ((immediate-desc? obj-desc)
      (lambda (cgc result-action args)
        (debug "Immediate value type check")
        (test-pointer-tag cgc result-action (car args) obj-desc)))

    ((reference-desc? obj-desc)
      (lambda (cgc result-action args)
        (debug "Reference value type check")
        (let* ((arg (car args))
               (suffix "_jump")
               (label (make-unique-label cgc suffix)))

          (test-pointer-tag
            cgc
            (then-jump #f label)
            arg
            obj-desc)

          ;; Continues execution only if tag match subtype or pair
          ;; Now check if header tag is valid

          (let* ((flipped (flip-bits (reference-header-tag obj-desc) header-tag-width))
                 (shifted (* (expt 2 header-tag-offset) flipped))
                 (cmp-opnd (int-opnd flipped)))
            ; Read then compare
            (read-reference cgc (get-extra-register 0) arg (get-desc-pointer-tag obj-desc) 0)
            ((prim-test cgc) cgc result-action (list (get-extra-register 0) cmp-opnd)))

          ;; If first test fails, jump here
          (am-lbl cgc label)
          (am-mov cgc (get-register 1) (int-opnd (car (format-object boolean-obj-desc #t))))
          (am-jmp cgc (get-register 0)))))
    (else
      (compiler-internal-error "Unknown object description"))))

(define (get-opnd-with-offset opnd offset)
  (case (opnd-type opnd)
    ('reg
      (mem-opnd offset opnd))
    ('mem
      (mem-opnd (+ (mem-opnd-offset opnd) offset) (mem-opnd-reg opnd)))
    ('lbl
      (lbl-opnd (lbl-opnd-label opnd) (+ (lbl-opnd-offset opnd) offset)))
    ('int
      (mem-opnd (+ (int-opnd-value opnd) offset)))))

(define (flip-bits num width)
  (- (- (expt 2 width) 1) num))