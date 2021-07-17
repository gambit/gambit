;;;============================================================================

;;; File: "unstable.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Experimental procedures. May be changed or removed at any time.

(##include "~~lib/_gambit#.scm")
(##include "unstable#.scm")

;;;----------------------------------------------------------------------------

;; TODO: The following are copied from lib/_num#.scm

(##define-macro (macro-make-exact-10^n-table)

  (define max-exact-power-of-10 22)
  ;; (floor (inexact->exact (/ (log (expt 2 (macro-flonum-m-bits-plus-1)))
  ;;                           (log 5))))

  (let loop ((i max-exact-power-of-10) (t '()))
    (if (>= i 0)
        (loop (- i 1) (cons (exact->inexact (expt 10 i)) t))
        `',(list->f64vector t))))

(define exact-10^n-table (macro-make-exact-10^n-table))

(define-prim&proc (make-inexact-real (mantissa exact-integer)
                                     (exponent exact-integer 0)
                                     (precision object #f))
  (if (and (fixnum? mantissa)
           (##fixnum->flonum-exact? mantissa)
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
      (exact->inexact (* mantissa (expt 10 exponent)))))

;;;============================================================================
