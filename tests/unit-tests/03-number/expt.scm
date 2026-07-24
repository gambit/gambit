(include "#.scm")

;;; Test values

(check-eqv? (expt 2 3) 8)
(check-eqv? (expt 2 -3) 1/8)
(check-eqv? (expt 8 1/3) 2)
(check-eqv? (expt 1+i 2) +2i)
(check-eqv? (expt +2i 1/2) 1+i)
(check-eqv? (expt +2i 3/2) -2+2i)
(check-eqv? (expt -2i 1/2) 1-i)
(check-eqv? (expt -2i 3/2) -2-2i)
(check-eqv? (expt -4 1/4) 1+i)
(check-eqv? (expt -4 3/4) -2+2i)
(check-eqv? (expt -4 5/4) -4-4i)
(check-eqv? (expt -64 1/6) (* 2 (make-rectangular (sqrt 3/4) 1/2)))
(check-eqv? (expt -64 5/6) (* 32 (make-rectangular (- (sqrt 3/4)) 1/2)))
(check-eqv? (expt (expt 1+1/10i 8) 3/8) (expt 1+1/10i 3))
(check-eqv? (expt 8/27 1/3) 2/3)
(check-eqv? (expt -8/27 1/3) 1/3+.5773502691896257i)
(check-eqv? (expt 4.0 1/2) 2.0)
(check-eqv? (expt 4 .5) 2.0)
(check-eqv? (expt 1+i 1/2) (sqrt 1+i))
(check-eqv? (expt -1 (expt 2 10000)) 1)
(check-eqv? (expt -1 (+ 1 (expt 2 10000))) -1)

;;; Checks from Matthew Flatt from the discussion here:
;;; https://github.com/racket/racket/issues/5228#issuecomment-3006098501

(check-eqv? (expt 0.0 -11) +inf.0)
(check-eqv? (expt 0.0 -1000000000000000000000000000000001) +inf.0)
(check-eqv? (expt 1e-320 -1000000000000000000000000000000001) +inf.0)

(check-eqv? (expt -0.0 -11) -inf.0)
(check-eqv? (expt -0.0 -1000000000000000000000000000000001) -inf.0)
(check-eqv? (expt -1e-320 -1000000000000000000000000000000001) -inf.0)


;; The following check was added as a result of issue #303 (faulty
;; C library ldexp and pow functions on OpenBSD/mips64el up to 6.2).
;; See: http://openbsd-archive.7691.n7.nabble.com/pow-returns-a-negative-result-on-loongson-td327877.html
(check-false (negative? (expt 0.5 1074.0)))

;;; Following test motivated by work by J Pelligrini on STKlos
;;; When the second argument is inexact, we don't know precisely
;;; the angle of the result, so the real part is inexact as well
;;; as the imaginary part.

(check-eqv? (expt -1 0.5) 0.+1.i)
(check-eqv? (expt -1. 1/2) +1.i)

;;; Some "white box" testing
;;; (nextafter 1. +inf.0) => 1.0000000000000002
;;; (nextafter 1. +.0   ) =>  .9999999999999999

(check-eqv? (flexpt 1.0000000000000002 (inexact (expt 2 63)))   +inf.0)
(check-eqv? (flexpt 1.0000000000000002 (inexact (- (expt 2 63)))) +0.0)

(check-eqv? (flexpt .9999999999999999 (inexact (expt 2 63)))       +0.0)
(check-eqv? (flexpt .9999999999999999 (inexact (- (expt 2 63)))) +inf.0)

(check-eqv? (expt 1.0000000000000002 (expt 2 63))   +inf.0)
(check-eqv? (expt 1.0000000000000002 (- (expt 2 63))) +0.0)

(check-eqv? (expt .9999999999999999 (expt 2 63))       +0.0)
(check-eqv? (expt .9999999999999999 (- (expt 2 63))) +inf.0)

(check-eqv? (expt -1.0000000000000002 (expt 2 63))   +inf.0)
(check-eqv? (expt -1.0000000000000002 (- (expt 2 63))) +0.0)

(check-eqv? (expt -.9999999999999999 (expt 2 63))       +0.0)
(check-eqv? (expt -.9999999999999999 (- (expt 2 63))) +inf.0)

(check-eqv? (expt 1.0000000000000002 (+ +1 (expt 2 63))) +inf.0)
(check-eqv? (expt 1.0000000000000002 (- -1 (expt 2 63)))   +0.0)

(check-eqv? (expt .9999999999999999 (+ +1 (expt 2 63)))   +0.0)
(check-eqv? (expt .9999999999999999 (- -1 (expt 2 63))) +inf.0)

(check-eqv? (expt -1.0000000000000002 (+ +1 (expt 2 63))) -inf.0)
(check-eqv? (expt -1.0000000000000002 (- -1 (expt 2 63)))   -0.0)

(check-eqv? (expt -.9999999999999999 (+ +1 (expt 2 63)))   -0.0)
(check-eqv? (expt -.9999999999999999 (- -1 (expt 2 63))) -inf.0)


;;; Test exceptions

(check-tail-exn type-exception? (lambda () (expt 'a 2)))
(check-tail-exn type-exception? (lambda () (expt 2 'a)))

;;; Tests motivated by https://en.cppreference.com/w/c/numeric/math/pow
;;; We tweak them to test (expt flonum exact-int), too.

;;; Either I'm OK with, or I don't know what to do with, commented failures.

;;     pow(+0, exponent), where exponent is a negative odd integer, returns +∞ and raises FE_DIVBYZERO
(check-eqv? (expt +0. -3.) +inf.0)
(check-eqv? (expt +0. -3) +inf.0)

;;     pow(-0, exponent), where exponent is a negative odd integer, returns -∞ and raises FE_DIVBYZERO
(check-eqv? (expt -0. -3.) -inf.0)
(check-eqv? (expt -0. -3) -inf.0)

;;     pow(±0, exponent), where exponent is negative, finite, and is an even integer or a non-integer, returns +∞ and raises FE_DIVBYZERO
(check-eqv? (expt +0. -4.) +inf.0)
(check-eqv? (expt -0. -4.) +inf.0)
(check-eqv? (expt +0. -4) +inf.0)
(check-eqv? (expt -0. -4) +inf.0)

;;     pow(±0, -∞) returns +∞ and may raise FE_DIVBYZERO(until C23)

(check-eqv? (expt +0. -inf.0) +inf.0)
;; (check-eqv? (expt -0. -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -0. -inf.0) +inf.0) GOT +nan.0+nan.0i


;;     pow(+0, exponent), where exponent is a positive odd integer, returns +0
(check-eqv? (expt +0. 3.) +0.)
(check-eqv? (expt +0. 3) +0.)


;;     pow(-0, exponent), where exponent is a positive odd integer, returns -0
(check-eqv? (expt -0. 3.) -0.)
(check-eqv? (expt -0. 3) -0.)

;;     pow(±0, exponent), where exponent is positive non-integer or a positive even integer, returns +0
(check-eqv? (expt +0. 2.) +0.)
(check-eqv? (expt -0. 2.) +0.)
(check-eqv? (expt +0. 2) +0.)
(check-eqv? (expt -0. 2) +0.)

;;     pow(-1, ±∞) returns 1
;; (check-eqv? (expt -1. +inf.0) 1.) ;; FAILED (check-eqv? (expt -1. +inf.0) 1.) GOT +nan.0+nan.0i
;; (check-eqv? (expt -1. -inf.0) 1.) ;; FAILED (check-eqv? (expt -1. -inf.0) 1.) GOT +nan.0+nan.0i

;;     pow(+1, exponent) returns 1 for any exponent, even when exponent is NaN
(check-eqv? (expt +1. +nan.0) +1.)
(check-eqv? (expt +1 +nan.0) +1)

;;     pow(base, ±0) returns 1 for any base, even when base is NaN
(check-eqv? (expt +nan.0 0.) 1.)
(check-eqv? (expt +nan.0 -0.) 1.)
(check-eqv? (expt +nan.0 0) 1)

;;     pow(base, exponent) returns NaN and raises FE_INVALID if base is finite and negative and exponent is finite and non-integer.
;;     This rule doesn't hold for expt in Gambit, which can return complex values.

;;     pow(base, -∞) returns +∞ for any |base|<1
(check-eqv? (expt 1/2 -inf.0) +inf.0)
;; (check-eqv? (expt -1/2 -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -1/2 -inf.0) +inf.0) GOT +nan.0+nan.0i
(check-eqv? (expt 0.5 -inf.0) +inf.0)
;; (check-eqv? (expt -0.5 -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -.5 -inf.0) +inf.0) GOT +nan.0+nan.0i


;;     pow(base, -∞) returns +0 for any |base|>1
(check-eqv? (expt 3/2 -inf.0) +0.)
;; (check-eqv? (expt -3/2 -inf.0) +0.) ;; FAILED (check-eqv? (expt -3/2 -inf.0) 0.) GOT +nan.0+nan.0i
(check-eqv? (expt 1.5 -inf.0) +0.)
;; (check-eqv? (expt -1.5 -inf.0) +0.) ;; FAILED (check-eqv? (expt -1.5 -inf.0) 0.) GOT +nan.0+nan.0i

;;     pow(base, +∞) returns +0 for any |base|<1
(check-eqv? (expt 1/2 +inf.0) +.0)
;; (check-eqv? (expt -1/2 +inf.0) +.0) ;; FAILED (check-eqv? (expt -1/2 +inf.0) 0.) GOT +nan.0+nan.0i
(check-eqv? (expt 0.5 +inf.0) +.0)
;; (check-eqv? (expt -0.5 +inf.0) +.0) ;; FAILED (check-eqv? (expt -.5 +inf.0) 0.) GOT +nan.0+nan.0i

;;     pow(base, +∞) returns +∞ for any |base|>1
(check-eqv? (expt 3/2 +inf.0) +inf.0)
;; (check-eqv? (expt -3/2 +inf.0) +inf.0) ;; FAILED (check-eqv? (expt -3/2 +inf.0) +inf.0) GOT +nan.0+nan.0i
(check-eqv? (expt 1.5 +inf.0) +inf.0)
;; (check-eqv? (expt -1.5 +inf.0) +inf.0) ;; FAILED (check-eqv? (expt -1.5 +inf.0) +inf.0) GOT +nan.0+nan.0i

;;     pow(-∞, exponent) returns -0 if exponent is a negative odd integer
(check-eqv? (expt -inf.0 -3) -0.)
(check-eqv? (expt -inf.0 -3.) -0.)

;;     pow(-∞, exponent) returns +0 if exponent is a negative non-integer or negative even integer
(check-eqv? (expt -inf.0 -2) +0.)
(check-eqv? (expt -inf.0 -2.) +0.)
;; (check-eqv? (expt -inf.0 -3/2) +0.)   ;; FAILED (check-eqv? (expt -inf.0 -3/2) 0.) GOT +0.i
;; (check-eqv? (expt -inf.0 #i-3/2) +0.) ;; FAILED (check-eqv? (expt -inf.0 -1.5) 0.) GOT -0.+0.i

;;     pow(-∞, exponent) returns -∞ if exponent is a positive odd integer
(check-eqv? (expt -inf.0 3) -inf.0)
(check-eqv? (expt -inf.0 3.) -inf.0)

;;     pow(-∞, exponent) returns +∞ if exponent is a positive non-integer or positive even integer
(check-eqv? (expt -inf.0 4) +inf.0)
(check-eqv? (expt -inf.0 4.) +inf.0)
;; (check-eqv? (expt -inf.0 #e4.5) +inf.0) ;; FAILED (check-eqv? (expt -inf.0 9/2) +inf.0) GOT +inf.0i
;; (check-eqv? (expt -inf.0 4.5) +inf.0)   ;; FAILED (check-eqv? (expt -inf.0 4.5) +inf.0) GOT +inf.0+inf.0i

;;     pow(+∞, exponent) returns +0 for any negative exponent
(check-eqv? (expt +inf.0 -4) +0.)
(check-eqv? (expt +inf.0 -3/2) +0.)
(check-eqv? (expt +inf.0 #i-4) +0.)
(check-eqv? (expt +inf.0 #i-3/2) +0.)

;;     pow(+∞, exponent) returns +∞ for any positive exponent
(check-eqv? (expt +inf.0 3) +inf.0)
(check-eqv? (expt +inf.0 3/2) +inf.0)
(check-eqv? (expt +inf.0 #i3) +inf.0)
(check-eqv? (expt +inf.0 #i3/2) +inf.0)

;;     except where specified above, if any argument is NaN, NaN is returned. 
(let ((test-value (expt +nan.0 2)))
  (check-false (= test-value test-value)))
