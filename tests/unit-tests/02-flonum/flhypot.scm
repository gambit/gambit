(include "#.scm")

;;; Test values

;;; If the implementation has error < 1 ulp, then it
;;; should give exact answers when the result is an integer.

(check-eqv? (flhypot 3. 4.) 5.)

#|

C99 rules:

If the implementation supports IEEE floating-point arithmetic (IEC 60559),

hypot(x, y), hypot(y, x), and hypot(x, -y) are equivalent
if one of the arguments is +/-0, hypot is equivalent to fabs called with the non-zero argument
if one of the arguments is +/-inf, hypot returns +inf even if the other argument is NaN
otherwise, if any of the arguments is NaN, NaN is returned 

|#

;; if one of the arguments is +/-0, hypot is equivalent to fabs called with the non-zero argument

(check-eqv? (flhypot +0. -1.) +1.)
(check-eqv? (flhypot +0. -0.) +0.)
(check-eqv? (flhypot -0. -1.) +1.)
(check-eqv? (flhypot -0. -0.) +0.)

;; if one of the arguments is +/-inf, hypot returns +inf even if the other argument is NaN

(check-eqv? (flhypot +inf.0 1.) +inf.0)
(check-eqv? (flhypot 1. +inf.0) +inf.0)
(check-eqv? (flhypot -inf.0 1.) +inf.0)
(check-eqv? (flhypot 1. -inf.0) +inf.0)
(check-eqv? (flhypot +inf.0 +nan.0) +inf.0)
(check-eqv? (flhypot +nan.0 +inf.0) +inf.0)
(check-eqv? (flhypot -inf.0 +nan.0) +inf.0)
(check-eqv? (flhypot +nan.0 -inf.0) +inf.0)

;; otherwise, if any of the arguments is NaN, NaN is returned

(check-eq? (isnan? (flhypot +nan.0 1.)) #t)
(check-eq? (isnan? (flhypot 1. +nan.0)) #t)

