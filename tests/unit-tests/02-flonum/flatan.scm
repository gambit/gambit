(include "#.scm")

(test-approximate 0.0 (flatan 0.0) 1e-12)
(test-approximate 0.7853981633974483 (flatan 1.0) 1e-12)
(test-approximate -0.7853981633974483 (flatan -1.0) 1e-12)

(test-assert (flnan? (flatan +nan.0)))

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

(test-approximate 3.141592653589793 (flatan +0. -1.) 1e-12)
(test-approximate 3.141592653589793 (flatan +0. -0.) 1e-12)
(test-approximate -3.141592653589793 (flatan -0. -1.) 1e-12)
(test-approximate -3.141592653589793 (flatan -0. -0.) 1e-12)

;; If y is +/-0 and x is positive or +0, +/-0 is returned

(test-approximate +0. (flatan +0. +1.) 1e-12)
(test-approximate +0. (flatan +0. +0.) 1e-12)
(test-approximate -0. (flatan -0. +1.) 1e-12)
(test-approximate -0. (flatan -0. +0.) 1e-12)

;; If y is +/-inf and x is finite, +/-pi/2 is returned

(test-approximate 1.5707963267948966 (flatan +inf.0 1.) 1e-12)
(test-approximate -1.5707963267948966 (flatan -inf.0 1.) 1e-12)

;; If y is +/-inf and x is -inf, +/-3pi/4 is returned

(test-approximate 2.356194490192345 (flatan +inf.0 -inf.0) 1e-12)
(test-approximate -2.356194490192345 (flatan -inf.0 -inf.0) 1e-12)

;; If y is +/-inf and x is +inf, +/-pi/4 is returned

(test-approximate 0.7853981633974483 (flatan +inf.0 +inf.0) 1e-12)
(test-approximate -0.7853981633974483 (flatan -inf.0 +inf.0) 1e-12)

;; If x is -inf and y is finite and positive, +pi is returned

(test-approximate 3.141592653589793 (flatan 1.0 -inf.0) 1e-12)

;; If x is -inf and y is finite and negative, -pi is returned

(test-approximate -3.141592653589793 (flatan -1. -inf.0) 1e-12)

;; If x is +inf and y is finite and positive, +0 is returned

(test-approximate +0. (flatan +1. +inf.0) 1e-12)

;; If x is +inf and y is finite and negative, -0 is returned

(test-approximate -0. (flatan -1. +inf.0) 1e-12)

;; If either x is NaN or y is NaN, NaN is returned

(test-assert (flnan? (flatan +nan.0 1.)))
(test-assert (flnan? (flatan 1. +nan.0)))

(test-error-tail wrong-number-of-arguments-exception? (flatan))
(test-error-tail wrong-number-of-arguments-exception? (flatan 1.0 2.0 3.0))

(test-error-tail type-exception? (flatan 1))
(test-error-tail type-exception? (flatan 1 2.0))
(test-error-tail type-exception? (flatan 1.0 2))
