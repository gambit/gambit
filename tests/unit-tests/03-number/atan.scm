(include "#.scm")

;;; Test special values

(test-eqv 0 (atan 0))

;;; Test branch cuts

(test-approximate (test-atan -2i) (atan -2i) 1e-12)
(test-approximate (test-atan 0.-2i) (atan 0.-2i) 1e-12)
(test-approximate (test-atan -0.-2i) (atan -0.-2i) 1e-12)
(test-approximate (test-atan +2i) (atan +2i) 1e-12)
(test-approximate (test-atan 0.+2i) (atan 0.+2i) 1e-12)
(test-approximate (test-atan -0.+2i) (atan -0.+2i) 1e-12)

;;; Test for a previous bug

(test-eqv (macro-inexact-+pi/2) (atan +inf.0 (expt 3 100000)))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (atan 1e-30+1e-40i))

;;; Test two-arg atan


;; If y is +/-0 and x is negative or -0, +/-pi is returned

(test-approximate (macro-inexact-+pi) (atan 0. -1.) 1e-12)
(test-approximate (macro-inexact-+pi) (atan 0. -0.) 1e-12)
(test-approximate (macro-inexact--pi) (atan -0. -1.) 1e-12)
(test-approximate (macro-inexact--pi) (atan -0. -0.) 1e-12)

;; If y is +/-0 and x is positive or +0, +/-0 is returned

(test-eqv 0. (atan 0. 1.))
(test-eqv 0. (atan 0. 0.))
(test-eqv -0. (atan -0. 1.))
(test-eqv -0. (atan -0. 0.))

;; If y is +/-inf and x is finite, +/-pi/2 is returned

(test-approximate (macro-inexact-+pi/2) (atan +inf.0 1.) 1e-12)
(test-approximate (macro-inexact--pi/2) (atan -inf.0 1.) 1e-12)

;; If y is +/-inf and x is -inf, +/-3pi/4 is returned

(test-approximate (macro-inexact-+3pi/4) (atan +inf.0 -inf.0) 1e-12)
(test-approximate (macro-inexact--3pi/4) (atan -inf.0 -inf.0) 1e-12)

;; If y is +/-inf and x is +inf, +/-pi/4 is returned

(test-approximate (macro-inexact-+pi/4) (atan +inf.0 +inf.0) 1e-12)
(test-approximate (macro-inexact--pi/4) (atan -inf.0 +inf.0) 1e-12)

;; If x is -inf and y is finite and positive, +pi is returned

(test-approximate (macro-inexact-+pi) (atan 1. -inf.0) 1e-12)

;; If x is -inf and y is finite and negative, -pi is returned

(test-approximate (macro-inexact--pi) (atan -1. -inf.0) 1e-12)

;; If x is +inf and y is finite and positive, +0 is returned

(test-eqv 0. (atan 1. +inf.0))

;; If x is +inf and y is finite and negative, -0 is returned

(test-eqv -0. (atan -1. +inf.0))

;; If either x is NaN or y is NaN, NaN is returned

(test-eq #t (isnan? (atan +nan.0 1.)))
(test-eq #t (isnan? (atan 1. +nan.0)))

;;; R7RS tests

(test-eqv 0 (atan 0 1))
(test-eqv 0. (atan 0. 1))
(test-eqv -0. (atan -0. 1))
(test-approximate (macro-inexact-+pi/4) (atan 1 1) 1e-12)
(test-approximate (macro-inexact-+pi/2) (atan 1 0) 1e-12)
(test-approximate (macro-inexact-+3pi/4) (atan 1 -1) 1e-12)
(test-approximate (macro-inexact-+pi) (atan 0 -1) 1e-12)
(test-approximate (macro-inexact-+pi) (atan 0. -1) 1e-12)
(test-approximate (macro-inexact--pi) (atan -0. -1) 1e-12)
(test-approximate (macro-inexact--3pi/4) (atan -1 -1) 1e-12)
(test-approximate (macro-inexact--pi/2) (atan -1 0) 1e-12)
(test-approximate (macro-inexact--pi/4) (atan -1 1) 1e-12)
(test-eqv 0 (atan 0 0))
;; undefined in R7RS
(test-eqv 0. (atan 0. 0.))
(test-eqv -0. (atan -0. 0.))
(test-approximate (macro-inexact-+pi) (atan 0. -0.) 1e-12)
(test-approximate (macro-inexact--pi) (atan -0. -0.) 1e-12)
(test-approximate (macro-inexact-+pi/2) (atan 0. 0) 1e-12)
(test-approximate (macro-inexact--pi/2) (atan -0. 0) 1e-12)

;;; Test exceptions

(test-error-tail type-exception? (atan 'a))

(test-error-tail range-exception? (atan -i))
(test-error-tail range-exception? (atan +i))

(test-error-tail type-exception? (atan 'a 2))
(test-error-tail type-exception? (atan 2 'a))
(test-error-tail type-exception? (atan 2 +i))
(test-error-tail type-exception? (atan +i 2))

