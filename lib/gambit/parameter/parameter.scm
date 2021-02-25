;;;============================================================================

;;; File: "parameter.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Parameter object operations.

(##include "parameter#.scm")

;;;----------------------------------------------------------------------------

(define ##parameter-counter 0)

(define-prim (##make-parameter
              init
              #!optional
              (sf (macro-absent-obj))
              (gf (macro-absent-obj)))
  (let* ((set-filter
          (if (##eq? sf (macro-absent-obj))
              ##identity
              sf))
         (get-filter
          (if (##eq? gf (macro-absent-obj))
              ##identity
              gf)))
    (macro-check-procedure set-filter 2 (make-parameter init sf gf)
      (macro-check-procedure get-filter 3 (make-parameter init sf gf)
        (let* ((val
                (set-filter init))
               (new-count
                (##fxwrap+ ##parameter-counter 1)))
          ;; Note: it is unimportant if the increment of
          ;; ##parameter-counter is not atomic; it simply means a
          ;; possible close repetition of the same hash code
          (set! ##parameter-counter new-count)
          (let ((descr
                 (macro-make-parameter-descr
                  val
                  (##partial-bit-reverse new-count)
                  set-filter
                  get-filter)))
            (letrec ((param
                      (lambda (#!optional (new-val (macro-absent-obj)))
                        (if (##eq? new-val (macro-absent-obj))
                            ((macro-parameter-descr-get-filter descr)
                             (##dynamic-ref param))
                            (##dynamic-set!
                             param
                             ((macro-parameter-descr-set-filter descr)
                              new-val))))))
              param)))))))

(define-prim (make-parameter
              init
              #!optional
              (sf (macro-absent-obj))
              (gf (macro-absent-obj)))
  (macro-force-vars (f)
    (##make-parameter init sf gf)))

;;;============================================================================
