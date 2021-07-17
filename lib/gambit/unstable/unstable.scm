;;;============================================================================

;;; File: "unstable.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Experimental procedures. May be changed or removed at any time.

(##include "unstable#.scm")

;;;----------------------------------------------------------------------------

;; TODO: The following are copied from lib/_num#.scm

(##define-macro (macro-inexact--1) -1.0)

(##define-macro (macro-make-exact-10^n-table)

  (define max-exact-power-of-10 22)
  ;; (floor (inexact->exact (/ (log (expt 2 (macro-flonum-m-bits-plus-1)))
  ;;                           (log 5))))

  (let ((t (make-vector (+ max-exact-power-of-10 1))))

    (let loop ((i max-exact-power-of-10))
      (if (not (< i 0))
          (begin
            (vector-set! t i (exact->inexact (expt 10 i)))
            (loop (- i 1)))))

    `',(list->f64vector (vector->list t))))

(define exact-10^n-table (macro-make-exact-10^n-table))

(define-prim&proc (make-inexact-real (negative? boolean)
                                     (mantissa nonnegative-exact-integer)
                                     (exponent nonnegative-exact-integer))
  (let ((n (if (and (fixnum? mantissa)
                    (fixnum->flonum-exact? mantissa)
                    (fixnum? exponent)
                    (fx< (fx- exponent)
                         (f64vector-length exact-10^n-table))
                    (fx< exponent
                         (f64vector-length exact-10^n-table)))
               (if (fx< exponent 0)
                   (fl/ (fixnum->flonum mantissa)
                        (f64vector-ref exact-10^n-table
                                       (fx- exponent)))
                   (fl* (fixnum->flonum mantissa)
                        (f64vector-ref exact-10^n-table
                                       exponent)))
               (exact->inexact
                (* mantissa (expt 10 exponent))))))
    (if negative?
        (flcopysign n (macro-inexact--1))
        n)))

;;;============================================================================
