(include "#.scm")

;;; Test special values

(check-eqv? (atan 0) 0)

;;; Test branch cuts

(check-= (atan -2i)    (test-atan -2i))
(check-= (atan +0.-2i) (test-atan 0.-2i))
(check-= (atan -0.-2i) (test-atan -0.-2i))
(check-= (atan +2i)    (test-atan +2i))
(check-= (atan +0.+2i) (test-atan 0.+2i))
(check-= (atan -0.+2i) (test-atan -0.+2i))

;;; Test for accuracy near 0

(check-eqv? (atan 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test two-arg atan

#|

If the implementation supports IEEE floating-point arithmetic (IEC 60559), 

If y is +/-0 and x is negative or -0, +/-pi is returned
If y is +/-0 and x is positive or +0, +/-0 is returned
If y is +/-inf and x is finite, +/-pi/2 is returned
If y is +/-inf and x is -inf, +/-3pi/4 is returned
If y is +/-inf and x is +inf, +/-pi/4 is returned
If x is +/-0 and y is negative, -pi/2 is returned
If x is +/-0 and y is positive, +pi/2 is returned
If x is -inf and y is finite and positive, +pi is returned
If x is -inf and y is finite and negative, -pi is returned
If x is +inf and y is finite and positive, +0 is returned
If x is +inf and y is finite and negative, -0 is returned
If either x is NaN or y is NaN, NaN is returned

|#

;; If y is +/-0 and x is negative or -0, +/-pi is returned

(check-= (atan +0. -1.) (macro-inexact-+pi))
(check-= (atan +0. -0.) (macro-inexact-+pi))
(check-= (atan -0. -1.) (macro-inexact--pi))
(check-= (atan -0. -0.) (macro-inexact--pi))

;; If y is +/-0 and x is positive or +0, +/-0 is returned

(check-eqv? (atan +0. +1.) +0.)
(check-eqv? (atan +0. +0.) +0.)
(check-eqv? (atan -0. +1.) -0.)
(check-eqv? (atan -0. +0.) -0.)

;; If y is +/-inf and x is finite, +/-pi/2 is returned

(check-= (atan +inf.0 1.) (macro-inexact-+pi/2))
(check-= (atan -inf.0 1.) (macro-inexact--pi/2))

;; If y is +/-inf and x is -inf, +/-3pi/4 is returned

(check-= (atan +inf.0 -inf.0) (macro-inexact-+3pi/4))
(check-= (atan -inf.0 -inf.0) (macro-inexact--3pi/4))

;; If y is +/-inf and x is +inf, +/-pi/4 is returned

(check-= (atan +inf.0 +inf.0) (macro-inexact-+pi/4))
(check-= (atan -inf.0 +inf.0) (macro-inexact--pi/4))

;; If x is -inf and y is finite and positive, +pi is returned

(check-= (atan 1.0 -inf.0) (macro-inexact-+pi))

;; If x is -inf and y is finite and negative, -pi is returned

(check-= (atan -1. -inf.0) (macro-inexact--pi))

;; If x is +inf and y is finite and positive, +0 is returned

(check-eqv? (atan +1. +inf.0) +0.)

;; If x is +inf and y is finite and negative, -0 is returned

(check-eqv? (atan -1. +inf.0) -0.)

;; If either x is NaN or y is NaN, NaN is returned

(check-eq? (isnan? (atan +nan.0 1.)) #t)
(check-eq? (isnan? (atan 1. +nan.0)) #t)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (atan 'a)))

(check-tail-exn range-exception? (lambda () (atan -i)))
(check-tail-exn range-exception? (lambda () (atan +i)))

(check-tail-exn type-exception? (lambda () (atan 'a 2)))
(check-tail-exn type-exception? (lambda () (atan 2 'a)))
(check-tail-exn type-exception? (lambda () (atan 2 +i)))
(check-tail-exn type-exception? (lambda () (atan +i 2)))

