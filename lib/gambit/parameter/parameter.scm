;;;============================================================================

;;; File: "parameter.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Parameter object operations.

(##include "parameter#.scm")

;;;----------------------------------------------------------------------------

(define ##parameter-counter 0)

(define-prim (##make-parameter
              init
              #!optional
              (f (macro-absent-obj)))
  (let ((filter
         (if (##eq? f (macro-absent-obj))
           (lambda (x) x)
           f)))
    (macro-check-procedure filter 2 (make-parameter init f)
      (let* ((val
              (filter init))
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
                filter)))
          (letrec ((param
                    (lambda (#!optional (new-val (macro-absent-obj)))
                      (if (##eq? new-val (macro-absent-obj))
                        (##dynamic-ref param)
                        (##dynamic-set!
                         param
                         ((macro-parameter-descr-filter descr) new-val))))))
            param))))))

(define-prim (make-parameter init #!optional (f (macro-absent-obj)))
  (macro-force-vars (f)
    (##make-parameter init f)))

;;;============================================================================
