;;==============================================================================

;;; File: "_t-cpu-abstract-machine.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;; ***** Primitives

;;  A primitive is a function taking:
;;  CGC
;;  ResultAction
;;  Arguments
;;    ResultAction = Copy location-opnd
;;                 | Branch true-jump-location false-jump-location
;;                 | Return fun-label fun-name
;;
;;  It also has some other values: arity, inlinable and testable.

(define (make-prim-obj fun arity inlinable testable)
  (vector 'prim fun arity inlinable testable))
(define (get-primitive-function prim-object)  (vector-ref prim-object 1))
(define (get-primitive-arity prim-object)     (vector-ref prim-object 2))
(define (get-primitive-inlinable prim-object) (vector-ref prim-object 3))
(define (get-primitive-testable prim-object)  (vector-ref prim-object 4))

(define (then-jump true-location false-location)
  (list 'jump true-location false-location))
(define (then-jump? then) (eqv? 'jump (car then)))
(define (then-jump-true-location then) (cadr then))
(define (then-jump-false-location then) (caddr then))

(define (then-move  store-location) (cons 'mov store-location))
(define (then-move? then) (eqv? 'mov (car then)))
(define (then-move-store-location then) (cdr then))

(define (then-return fun-label fun-name) (list 'return fun-label fun-name))
(define (then-return? then) (eqv? 'return (car then)))
(define (then-return-label then) (cadr then))
(define (then-return-prim-name then) (caddr then))

(define then-nothing 'nop)
(define (then-nothing? then) (equal? 'nop then))

;; ***** Primitives - High level instructions

(define (am-if cgc opnd1 opnd2 condition on-true on-false #!optional (actions-return #f) (opnds-width #f))
  (let ((true-label (make-unique-label cgc "if-true" #f))
        (false-label (make-unique-label cgc "if-false" #f))
        (continue-label (make-unique-label cgc "continue-label" #f)))
    (cond
      ((and on-true on-false)
        (am-compare-jump cgc condition opnd1 opnd2 #f false-label opnds-width)
        (on-true cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label))
        (am-lbl cgc false-label)
        (on-false cgc)
        (am-lbl cgc continue-label))
      (on-true
        (am-compare-jump cgc condition opnd1 opnd2 #f continue-label opnds-width)
        (on-true cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label)))
      (on-false
        (am-compare-jump cgc condition opnd1 opnd2 continue-label #f opnds-width)
        (on-false cgc)
        (if (not actions-return)
          (am-jmp cgc continue-label))))))

(define (am-if-eq cgc opnd1 opnd2 on-true on-false #!optional (actions-return #f) (opnds-width #f))
  (am-if cgc opnd1 opnd2 condition-equal on-true on-false actions-return opnds-width))

(define (am-return-const cgc result-action value)
  (debug "am-return-const")
  (debug "result-action: " result-action)
  (cond
    ((then-jump? result-action)
      (if value
        (if (then-jump-true-location result-action)
          (am-jmp cgc (then-jump-true-location result-action)))
        (if (then-jump-false-location result-action)
          (am-jmp cgc (then-jump-false-location result-action)))))
    ((then-move? result-action)
      (am-mov
        cgc
        (then-move-store-location result-action)
        (make-obj-opnd cgc value)))
    ((then-return? result-action)
      (am-mov
        cgc
        (get-register cgc 1)
        (make-obj-opnd cgc value))
      (am-jmp cgc (get-register cgc 0)))
    (then-nothing?
      (debug "result-action is nop"))
    (else
      (compiler-internal-error "prim-const-return - Unknown result-action" result-action))))

(define (am-return-opnd cgc result-action opnd #!key (opnd-not-false #f))
  (debug "am-return-opnd")
  (debug "result-action: " result-action)
  (cond
    ((then-jump? result-action)
      (let ((false-opnd (make-obj-opnd cgc #f))
            (true-jmp (then-jump-true-location result-action))
            (false-jmp (then-jump-false-location result-action)))
        (if opnd-not-false
          (if true-jmp (am-jmp cgc true-jmp))
          (mov-if-necessary cgc '(reg mem) opnd
            (lambda (opnd)
            (am-compare-jump cgc
              condition-not-equal
              opnd false-opnd
              true-jmp false-jmp
              (get-word-width-bits cgc)))))))
    ((then-move? result-action)
      (let ((mov-loc (then-move-store-location result-action)))
        (if (not (equal? mov-loc opnd))
          (am-mov cgc mov-loc opnd))))
    ((then-return? result-action)
      (if (not (equal? (get-register cgc 1) opnd))
        (am-mov cgc (get-register cgc 1) opnd))
      (am-jmp cgc (get-register cgc 0)))
    (then-nothing?
      (debug "result-action is nop"))
    (else
      (compiler-internal-error "prim-const-return - Unknown result-action" result-action))))

; (lambda (cgc true-label false-label))
(define (am-return-boolean cgc result-action action)
  (debug "am-return-boolean")
  (let ((true-label (make-unique-label cgc "if-true" #f))
        (false-label (make-unique-label cgc "if-false" #f))
        (continue-label (make-unique-label cgc "continue-label" #f)))
    (cond
      ((then-jump? result-action)
        (let ((true-jmp (then-jump-true-location result-action))
              (false-jmp (then-jump-false-location result-action)))
          (action true-jmp false-jmp)))
      ((then-move? result-action)
        (let ((mov-loc (then-move-store-location result-action)))
          (action true-label false-label)

          (am-lbl cgc true-label)
          (am-mov cgc mov-loc (make-obj-opnd cgc #t))
          (am-jmp cgc continue-label)

          (am-lbl cgc false-label)
          (am-mov cgc mov-loc (make-obj-opnd cgc #f))
          (am-lbl cgc continue-label)))
      ((then-return? result-action)
        (action true-label false-label)

        (am-lbl cgc true-label)
        (am-mov cgc (get-register cgc 1) (make-obj-opnd cgc #t))
        (am-jmp cgc continue-label)

        (am-lbl cgc false-label)
        (am-mov cgc (get-register cgc 1) (make-obj-opnd cgc #f))

        (am-lbl cgc continue-label)
        (am-jmp cgc (get-register cgc 0)))
      (then-nothing?
        (debug "result-action is nop")
        (action true-label false-label)
        (am-lbl cgc true-label)
        (am-lbl cgc false-label))
      (else
        (compiler-internal-error "prim-const-return - Unknown result-action" result-action)))))

(define (foldl-prim reduce-2+
          #!key (allowed-opnds '(reg))
                (allowed-opnds-accum '(reg))
                (start-value 'none)
                (start-value-null? #f)
                (reduce-1 #f)
                (commutative #f))

  (define (none? a) (equal? 'none a))

  (lambda (cgc result-action args)
    (debug "foldl-prim")

    ;; The difference between a function and an inlined function is that the
    ;; arguments for the inlined function are unrolled while they are placed in
    ;; a list as the last argument of the function.
    (if (then-return? result-action)
      ;; Is a function.
      #f ;; Todo
      ;; Is inlined.
      (cond
        ((and (null? args) (none? start-value))
          (compiler-internal-error
            "foldl-prim - Prim doesn't have a start-value"))
        ;; Empty case
        ((null? args)
          (am-return-const cgc result-action start-value))
        ;; 1 argument case
        ((null? (cdr args))
          (with-result-opnd cgc result-action args
            commutative: commutative
            allowed-opnds: allowed-opnds-accum
            fun:
              (lambda (accum accum-in-args)
                (reduce-1 cgc accum (car args))
                (am-return-opnd cgc result-action accum))))
        ;; General case
        (else
          (with-result-opnd cgc result-action args
            commutative: commutative
            allowed-opnds: allowed-opnds-accum
            ;; Start-value is the identity value => Can skip it
            default-opnd: (if (or (none? start-value) start-value-null?) (car args) #f)
            fun: (lambda (accum accum-in-args)
              (let ((new-args
                ;; Remove accum from args if accum is in opnd. Happens if commutative
                (if accum-in-args
                  (filter (lambda (opnd) (not (equal? accum opnd))) args)
                  ;; Remove first element as it's used to initialize accum
                  (if (or (none? start-value) start-value-null?)
                    (cdr args)
                    args))))

                ;; Initialize accum if necessary
                (if (not accum-in-args)
                  (cond
                    ((or (none? start-value) start-value-null?)
                      (am-mov cgc accum (car args)))
                    ((not start-value-null?)
                      (am-mov cgc accum (make-obj-opnd cgc start-value)))
                    (else
                      (compiler-internal-error "foldl-prim : No start-value"))))

                ;; Fold over arguments
                (let loop ((loop-args new-args))
                  (if (not (null? loop-args))
                    ;; Mov car args if necessary
                    (begin
                      (mov-if-necessary cgc allowed-opnds (car loop-args)
                        (lambda (arg)
                          (reduce-2+ cgc accum arg)))
                      (loop (cdr loop-args)))))

                (am-return-opnd cgc result-action accum)))))))))

(define (foldl-compare-prim reduce-2+
          #!key (allowed-opnds1 '(reg))
                (allowed-opnds2 '(reg))
                (reduce-1 #t) ;; Or can be function (Todo and necessary?)
                (empty-val #t)
                (commutative #f))
  (lambda (cgc result-action args)
    (debug "foldl-compare-prim")

    ;; The difference between a function and an inlined function is that the
    ;; arguments for the inlined function are unrolled while they are placed in
    ;; a list as the last argument of the function.
    (if (then-return? result-action)
      ;; Is a function.
      #f ;; Todo
      ;; Is inlined.
      (cond
        ;; Empty case
        ((null? args)
          (debug "empty case")
          (am-return-const cgc result-action empty-val))
        ;; 1 argument case
        ((null? (cdr args))
          (debug "1 argument case")
          (am-return-const cgc result-action reduce-1))
        ;; General case
        (else
          (debug "general case")
          (am-return-boolean cgc result-action
            (lambda (true-label false-label)
              (for-each
                (lambda (opnd1 opnd2)
                  ;; Mov car args if necessary
                  (mov-if-necessary cgc allowed-opnds1 opnd1
                    (lambda (arg1)
                      (mov-if-necessary cgc allowed-opnds2 opnd2
                        (lambda (arg2)
                          (reduce-2+ cgc arg1 arg2 true-label false-label))))))
                (cdr args)
                args))))))))

(define (foldl-boolean-prim reduce-1 end-value
          #!key (allowed-opnds '(reg))
                (empty-val #t))
  (lambda (cgc result-action args)
    (debug "foldl-boolean-prim")

    ;; The difference between a function and an inlined function is that the
    ;; arguments for the inlined function are unrolled while they are placed in
    ;; a list as the last argument of the function.
    (if (then-return? result-action)
      ;; Is a function.
      #f ;; Todo
      ;; Is inlined.
      (cond
        ;; Empty case
        ((null? args)
          (am-return-const cgc result-action empty-val))
        ;; General case
        (else
          (am-return-boolean cgc result-action
            (lambda (true-label false-label)
              (for-each
                (lambda (opnd)
                  ;; Mov car args if necessary
                  (mov-if-necessary cgc allowed-opnds opnd
                    (lambda (arg)
                      (reduce-1 cgc arg true-label false-label))))
                args)

              (if end-value
                (am-jmp true-label)
                (am-jmp false-label)))))))))

;; ***** Primitives - High level instructions - Utils

(define (with-result-opnd cgc result-action args
          #!key fun
          (commutative #f)
          (single-instruction #f)
          (allowed-opnds '(reg int mem))
          (default-opnd #f))

  (define (use-loc loc in-args?)
    (if (and loc (elem? (opnd-type cgc loc) allowed-opnds))
      (fun loc in-args?)
      (get-free-register cgc
        (lambda (reg)
          (fun reg #f)
          (am-mov cgc loc reg)))))

  (define (use-extra-reg loc)
    (get-free-register cgc
      (lambda (reg)
        (fun reg #f)
        (am-mov cgc loc reg))))

  (define loc-in-args-count (elem-count (get-register cgc 1) args))
  (define not-in-args (= 0 loc-in-args-count))
  (define once-in-args (= 1 loc-in-args-count))

  (cond
    ((then-jump? result-action)
      (use-loc default-opnd #t))
    ((then-move? result-action)
      (let ((mov-loc (then-move-store-location result-action)))
        (cond
          ;; We can rearrange the expression to remove redundant move
          ((and once-in-args commutative)
            (use-loc mov-loc #t))
          ;; We can overwrite mov-loc.
          (not-in-args
            (use-loc mov-loc #f))
          (default-opnd
            (use-loc default-opnd #f))
          (else
            (use-extra-reg mov-loc)))))
    ((then-return? result-action)
      ;; We can rearrange the expression to remove redundant move
      (cond
        (single-instruction
          (use-loc (get-register cgc 1) once-in-args))
        ((and once-in-args commutative)
          (use-loc (get-register cgc 1) #t))
        (not-in-args
          (use-loc (get-register cgc 1) #f))
        (default-opnd
          (use-loc default-opnd #t))
        (else
          (use-extra-reg (get-register cgc 1)))))
    (then-nothing?
      (debug "result-action is nop")
      (get-free-register cgc (lambda (reg) (fun reg #f))))
    (else
      (compiler-internal-error "with-result-opnd - Unknown result-action" result-action))))

(define (check-nargs-if-necessary cgc result-action nargs
          #!key (optional-args-values '()) (rest? #f))
  (if (then-return? result-action)
    (am-check-nargs
      cgc
      (then-return-label result-action)
      (get-fun-fs cgc nargs)
      nargs
      optional-args-values
      rest?
      (lambda (fun-label)
        (put-entry-point-label cgc
          fun-label
          (then-return-prim-name result-action) #f
          nargs #f)))))

(define (call-with-nargs args fun)
  (apply fun args))

(define (mov-if-necessary cgc allowed-opnds opnd fun)
  (if (elem? (opnd-type cgc opnd) allowed-opnds)
    (fun opnd)
    (get-free-register cgc
      (lambda (reg)
        (am-mov cgc reg opnd)
        (fun reg)))))

;; ***** Primitives - Basic primitives (##Identity and ##not)

(define (##identity-primitive cgc result-action args)
  (check-nargs-if-necessary cgc result-action 1)
  (call-with-nargs args
    (lambda (arg1)
      (debug "identity prim")
      (am-return-opnd cgc result-action arg1))))

(define (##not cgc result-action args)
  (check-nargs-if-necessary cgc result-action 1)
  (call-with-nargs args
    (lambda (arg1)
      (debug "identity not")
      (am-if-eq cgc arg1 (make-obj-opnd cgc #f)
        (lambda (cgc) (am-return-const cgc result-action #t))
        (lambda (cgc) (am-return-const cgc result-action #f))
        #f
        (get-word-width-bits cgc)))))

;; ***** Primitives - Default Primitives - Type checks

;; Todo

;; ***** Primitives - Default Primitives - Memory read/write/test

;; Todo: Dereference memory before reading with offset (Doesn't work)
(define (read-reference cgc result-action dest ref tag index width)
  (let* ((total-offset (- (* width index) tag)))
    (if (equal? 'reg (opnd-type cgc ref))
      (am-mov cgc dest (get-opnd-with-offset cgc ref total-offset))
      (begin
        (get-free-register cgc
          (lambda (reg)
            (am-mov cgc reg ref)
            (am-mov cgc dest (get-opnd-with-offset cgc reg total-offset))))))))

(define (set-reference cgc src ref tag index width)
  (let* ((total-offset (- (* width index) tag))
         (mem-location (get-opnd-with-offset cgc ref total-offset)))
    (am-mov cgc mem-location src)))

; (define (read-reference-dynamic cgc dest ref tag index-opnd width)
;   (let* ((total-offset (- (* width index) tag))
;          (mem-location (get-opnd-with-offset cgc ref total-offset)))
;     (am-mov cgc dest mem-location)))

; (define (set-reference-dynamic cgc src ref tag index width)
;   (let* ((total-offset (- (* width index) tag))
;          (mem-location (get-opnd-with-offset cgc ref total-offset)))
;     (am-mov cgc mem-location dest)))

(define (object-read-prim desc field-index #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (if field-index
    ;; Index is static
    (lambda (cgc result-action args)
      (debug "object-read-prim")
      (with-result-opnd cgc result-action args
        single-instruction: #t
        fun: (lambda (result-opnd result-opnd-in-args)
          (check-nargs-if-necessary cgc result-action 1)
          (mov-if-necessary cgc '(reg mem) (car args)
            (lambda (ref)
              (read-reference cgc result-action
                result-opnd ref
                (get-desc-pointer-tag desc)
                (- field-index 1)
                (if width width (get-word-width cgc))))))))
    (compiler-internal-error "object-set-prim - Dynamic index not implemented")))

(define (object-set-prim desc field-index #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (if field-index
    ;; Index is static
    (lambda (cgc result-action args)
      (check-nargs-if-necessary cgc result-action 2)
      (call-with-nargs args
        (lambda (ref new-val)
          (set-reference cgc
            new-val ref
            (get-desc-pointer-tag desc) (- field-index 1)
            (if width width (get-word-width cgc)))
          (am-return-const cgc result-action (void)))))
  (compiler-internal-error "object-set-prim - Dynamic index not implemented")))
