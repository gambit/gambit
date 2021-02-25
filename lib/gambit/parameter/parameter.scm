;;;============================================================================

;;; File: "parameter.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Parameter object operations.

(##include "parameter#.scm")

;;;----------------------------------------------------------------------------

(define ##parameter-counter 0)

(define-prim&proc (make-parameter init
                                  (set-filter procedure identity)
                                  (get-filter procedure identity))
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
        param))))

;;;============================================================================
