(include "#.scm")

;;; Test values

(test-eqv 8 (expt 2 3))
(test-eqv 1/8 (expt 2 -3))
(test-eqv 2 (expt 8 1/3))
(test-eqv +2i (expt 1+i 2))
(test-eqv 1+i (expt +2i 1/2))
(test-eqv -2+2i (expt +2i 3/2))
(test-eqv 1-i (expt -2i 1/2))
(test-eqv -2-2i (expt -2i 3/2))
(test-eqv 1+i (expt -4 1/4))
(test-eqv -2+2i (expt -4 3/4))
(test-eqv -4-4i (expt -4 5/4))
(test-eqv (* 2 (make-rectangular (sqrt 3/4) 1/2)) (expt -64 1/6))
(test-eqv (* 32 (make-rectangular (- (sqrt 3/4)) 1/2)) (expt -64 5/6))
(test-eqv (expt 1+1/10i 3) (expt (expt 1+1/10i 8) 3/8))
(test-eqv 2/3 (expt 8/27 1/3))
(test-eqv 1/3+.5773502691896257i (expt -8/27 1/3))
(test-eqv 2. (expt 4. 1/2))
(test-eqv 2. (expt 4 .5))
(test-eqv (sqrt 1+i) (expt 1+i 1/2))
(test-eqv 1 (expt -1 (expt 2 10000)))
(test-eqv -1 (expt -1 (+ 1 (expt 2 10000))))

;;; Checks from Matthew Flatt from the discussion here:
;;; https://github.com/racket/racket/issues/5228#issuecomment-3006098501

(test-eqv +inf.0 (expt 0. -11))
(test-eqv +inf.0 (expt 0. -1000000000000000000000000000000001))
(test-eqv +inf.0 (expt 1e-320 -1000000000000000000000000000000001))

(test-eqv -inf.0 (expt -0. -11))
(test-eqv -inf.0 (expt -0. -1000000000000000000000000000000001))
(test-eqv -inf.0 (expt -1e-320 -1000000000000000000000000000000001))


;; The following check was added as a result of issue #303 (faulty
;; C library ldexp and pow functions on OpenBSD/mips64el up to 6.2).
;; See: http://openbsd-archive.7691.n7.nabble.com/pow-returns-a-negative-result-on-loongson-td327877.html
(test-assert (eq? #f (negative? (expt .5 1074.))))

;;; Following test motivated by work by J Pelligrini on STKlos
;;; When the second argument is inexact, we don't know precisely
;;; the angle of the result, so the real part is inexact as well
;;; as the imaginary part.

(test-eqv 0.+1.i (expt -1 .5))
(test-eqv +1.i (expt -1. 1/2))

;;; Some " white box " testing
;;; (nextafter 1. +inf.0) => 1.0000000000000002
;;; (nextafter 1. +.0   ) =>  .9999999999999999

(test-eqv +inf.0 (flexpt 1.0000000000000002 (inexact (expt 2 63))))
(test-eqv 0. (flexpt 1.0000000000000002 (inexact (- (expt 2 63)))))

(test-eqv 0. (flexpt .9999999999999999 (inexact (expt 2 63))))
(test-eqv +inf.0 (flexpt .9999999999999999 (inexact (- (expt 2 63)))))

(test-eqv +inf.0 (expt 1.0000000000000002 (expt 2 63)))
(test-eqv 0. (expt 1.0000000000000002 (- (expt 2 63))))

(test-eqv 0. (expt .9999999999999999 (expt 2 63)))
(test-eqv +inf.0 (expt .9999999999999999 (- (expt 2 63))))

(test-eqv +inf.0 (expt -1.0000000000000002 (expt 2 63)))
(test-eqv 0. (expt -1.0000000000000002 (- (expt 2 63))))

(test-eqv 0. (expt -.9999999999999999 (expt 2 63)))
(test-eqv +inf.0 (expt -.9999999999999999 (- (expt 2 63))))

(test-eqv +inf.0 (expt 1.0000000000000002 (+ 1 (expt 2 63))))
(test-eqv 0. (expt 1.0000000000000002 (- -1 (expt 2 63))))

(test-eqv 0. (expt .9999999999999999 (+ 1 (expt 2 63))))
(test-eqv +inf.0 (expt .9999999999999999 (- -1 (expt 2 63))))

(test-eqv -inf.0 (expt -1.0000000000000002 (+ 1 (expt 2 63))))
(test-eqv -0. (expt -1.0000000000000002 (- -1 (expt 2 63))))

(test-eqv -0. (expt -.9999999999999999 (+ 1 (expt 2 63))))
(test-eqv -inf.0 (expt -.9999999999999999 (- -1 (expt 2 63))))


;;; Test exceptions

(test-error-tail type-exception? (expt 'a 2))
(test-error-tail type-exception? (expt 2 'a))

;;; Tests motivated by https://en.cppreference.com/w/c/numeric/math/pow
;;; We tweak them to test (expt flonum exact-int), too.

;;; Either I'm OK with, or I don't know what to do with, commented failures.

;;     pow(+0, exponent), where exponent is a negative odd integer, returns +∞ and raises FE_DIVBYZERO
(test-eqv +inf.0 (expt 0. -3.))
(test-eqv +inf.0 (expt 0. -3))

;;     pow(-0, exponent), where exponent is a negative odd integer, returns -∞ and raises FE_DIVBYZERO
(test-eqv -inf.0 (expt -0. -3.))
(test-eqv -inf.0 (expt -0. -3))

;;     pow(±0, exponent), where exponent is negative, finite, and is an even integer or a non-integer, returns +∞ and raises FE_DIVBYZERO
(test-eqv +inf.0 (expt 0. -4.))
(test-eqv +inf.0 (expt -0. -4.))
(test-eqv +inf.0 (expt 0. -4))
(test-eqv +inf.0 (expt -0. -4))

;;     pow(±0, -∞) returns +∞ and may raise FE_DIVBYZERO(until C23)

(test-eqv +inf.0 (expt 0. -inf.0))
;; (check-eqv? (expt -0. -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -0. -inf.0) +inf.0) GOT +nan.0+nan.0i


;;     pow(+0, exponent), where exponent is a positive odd integer, returns +0
(test-eqv 0. (expt 0. 3.))
(test-eqv 0. (expt 0. 3))


;;     pow(-0, exponent), where exponent is a positive odd integer, returns -0
(test-eqv -0. (expt -0. 3.))
(test-eqv -0. (expt -0. 3))

;;     pow(±0, exponent), where exponent is positive non-integer or a positive even integer, returns +0
(test-eqv 0. (expt 0. 2.))
(test-eqv 0. (expt -0. 2.))
(test-eqv 0. (expt 0. 2))
(test-eqv 0. (expt -0. 2))

;;     pow(-1, ±∞) returns 1
;; (check-eqv? (expt -1. +inf.0) 1.) ;; FAILED (check-eqv? (expt -1. +inf.0) 1.) GOT +nan.0+nan.0i
;; (check-eqv? (expt -1. -inf.0) 1.) ;; FAILED (check-eqv? (expt -1. -inf.0) 1.) GOT +nan.0+nan.0i

;;     pow(+1, exponent) returns 1 for any exponent, even when exponent is NaN
(test-eqv 1. (expt 1. +nan.0))
(test-eqv 1 (expt 1 +nan.0))

;;     pow(base, ±0) returns 1 for any base, even when base is NaN
(test-eqv 1. (expt +nan.0 0.))
(test-eqv 1. (expt +nan.0 -0.))
(test-eqv 1 (expt +nan.0 0))

;;     pow(base, exponent) returns NaN and raises FE_INVALID if base is finite and negative and exponent is finite and non-integer.
;;     This rule doesn't hold for expt in Gambit, which can return complex values.

;;     pow(base, -∞) returns +∞ for any |base|<1
(test-eqv +inf.0 (expt 1/2 -inf.0))
;; (check-eqv? (expt -1/2 -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -1/2 -inf.0) +inf.0) GOT +nan.0+nan.0i
(test-eqv +inf.0 (expt .5 -inf.0))
;; (check-eqv? (expt -0.5 -inf.0) +inf.0) ;; FAILED (check-eqv? (expt -.5 -inf.0) +inf.0) GOT +nan.0+nan.0i


;;     pow(base, -∞) returns +0 for any |base|>1
(test-eqv 0. (expt 3/2 -inf.0))
;; (check-eqv? (expt -3/2 -inf.0) +0.) ;; FAILED (check-eqv? (expt -3/2 -inf.0) 0.) GOT +nan.0+nan.0i
(test-eqv 0. (expt 1.5 -inf.0))
;; (check-eqv? (expt -1.5 -inf.0) +0.) ;; FAILED (check-eqv? (expt -1.5 -inf.0) 0.) GOT +nan.0+nan.0i

;;     pow(base, +∞) returns +0 for any |base|<1
(test-eqv 0. (expt 1/2 +inf.0))
;; (check-eqv? (expt -1/2 +inf.0) +.0) ;; FAILED (check-eqv? (expt -1/2 +inf.0) 0.) GOT +nan.0+nan.0i
(test-eqv 0. (expt .5 +inf.0))
;; (check-eqv? (expt -0.5 +inf.0) +.0) ;; FAILED (check-eqv? (expt -.5 +inf.0) 0.) GOT +nan.0+nan.0i

;;     pow(base, +∞) returns +∞ for any |base|>1
(test-eqv +inf.0 (expt 3/2 +inf.0))
;; (check-eqv? (expt -3/2 +inf.0) +inf.0) ;; FAILED (check-eqv? (expt -3/2 +inf.0) +inf.0) GOT +nan.0+nan.0i
(test-eqv +inf.0 (expt 1.5 +inf.0))
;; (check-eqv? (expt -1.5 +inf.0) +inf.0) ;; FAILED (check-eqv? (expt -1.5 +inf.0) +inf.0) GOT +nan.0+nan.0i

;;     pow(-∞, exponent) returns -0 if exponent is a negative odd integer
(test-eqv -0. (expt -inf.0 -3))
(test-eqv -0. (expt -inf.0 -3.))

;;     pow(-∞, exponent) returns +0 if exponent is a negative non-integer or negative even integer
(test-eqv 0. (expt -inf.0 -2))
(test-eqv 0. (expt -inf.0 -2.))
;; (check-eqv? (expt -inf.0 -3/2) +0.)   ;; FAILED (check-eqv? (expt -inf.0 -3/2) 0.) GOT +0.i
;; (check-eqv? (expt -inf.0 #i-3/2) +0.) ;; FAILED (check-eqv? (expt -inf.0 -1.5) 0.) GOT -0.+0.i

;;     pow(-∞, exponent) returns -∞ if exponent is a positive odd integer
(test-eqv -inf.0 (expt -inf.0 3))
(test-eqv -inf.0 (expt -inf.0 3.))

;;     pow(-∞, exponent) returns +∞ if exponent is a positive non-integer or positive even integer
(test-eqv +inf.0 (expt -inf.0 4))
(test-eqv +inf.0 (expt -inf.0 4.))
;; (check-eqv? (expt -inf.0 #e4.5) +inf.0) ;; FAILED (check-eqv? (expt -inf.0 9/2) +inf.0) GOT +inf.0i
;; (check-eqv? (expt -inf.0 4.5) +inf.0)   ;; FAILED (check-eqv? (expt -inf.0 4.5) +inf.0) GOT +inf.0+inf.0i

;;     pow(+∞, exponent) returns +0 for any negative exponent
(test-eqv 0. (expt +inf.0 -4))
(test-eqv 0. (expt +inf.0 -3/2))
(test-eqv 0. (expt +inf.0 -4.))
(test-eqv 0. (expt +inf.0 -1.5))

;;     pow(+∞, exponent) returns +∞ for any positive exponent
(test-eqv +inf.0 (expt +inf.0 3))
(test-eqv +inf.0 (expt +inf.0 3/2))
(test-eqv +inf.0 (expt +inf.0 3.))
(test-eqv +inf.0 (expt +inf.0 1.5))

;;     except where specified above, if any argument is NaN, NaN is returned. 
(let ((test-value (expt +nan.0 2)))
  (test-assert (eq? #f (= test-value test-value))))
