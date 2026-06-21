(include "#.scm")

;;; Test values

;;; If the implementation has error < 1 ulp, then it
;;; should give exact answers when the result is an integer.

(test-eqv 5. (flhypot 3. 4.))

#|

C99 rules:

If the implementation supports IEEE floating-point arithmetic (IEC 60559),

hypot(x, y), hypot(y, x), and hypot(x, -y) are equivalent
if one of the arguments is +/-0, hypot is equivalent to fabs called with the non-zero argument
if one of the arguments is +/-inf, hypot returns +inf even if the other argument is NaN
otherwise, if any of the arguments is NaN, NaN is returned 

|#

;; if one of the arguments is +/-0, hypot is equivalent to fabs called with the non-zero argument

(test-eqv +1. (flhypot +0. -1.))
(test-eqv +0. (flhypot +0. -0.))
(test-eqv +1. (flhypot -0. -1.))
(test-eqv +0. (flhypot -0. -0.))

;; if one of the arguments is +/-inf, hypot returns +inf even if the other argument is NaN

(test-eqv +inf.0 (flhypot +inf.0 1.))
(test-eqv +inf.0 (flhypot 1. +inf.0))
(test-eqv +inf.0 (flhypot -inf.0 1.))
(test-eqv +inf.0 (flhypot 1. -inf.0))
(test-eqv +inf.0 (flhypot +inf.0 +nan.0))
(test-eqv +inf.0 (flhypot +nan.0 +inf.0))
(test-eqv +inf.0 (flhypot -inf.0 +nan.0))
(test-eqv +inf.0 (flhypot +nan.0 -inf.0))

;; otherwise, if any of the arguments is NaN, NaN is returned

(test-assert (flnan? (flhypot +nan.0 1.)))
(test-assert (flnan? (flhypot 1. +nan.0)))

(test-error-tail wrong-number-of-arguments-exception? (flhypot))
(test-error-tail wrong-number-of-arguments-exception? (flhypot 1.0))
(test-error-tail wrong-number-of-arguments-exception? (flhypot 1.0 2.0 3.0))

(test-error-tail type-exception? (flhypot 1 2.0))
(test-error-tail type-exception? (flhypot 1.0 2))
