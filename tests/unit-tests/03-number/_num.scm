(include "#.scm")

;;; These tests come from coverage statistics for part of _num.scm

(test-error-tail type-exception? (finite? 'a))
(test-eqv #t (finite? 0))
(test-eqv #t (finite? 1))
(test-eqv #t (finite? 99999999999999999999999999999999))
(test-eqv #t (finite? 1/2))
(test-eqv #t (finite? 0.))
(test-eqv #t (finite? 1.5))
(test-eqv #f (finite? +inf.0))
(test-eqv #f (finite? +nan.0))
(test-eqv #t (finite? 0))
(test-eqv #t (finite? +i))
(test-eqv #t (finite? +99999999999999999999999999999999i))
(test-eqv #t (finite? +1/2i))
(test-eqv #t (finite? +0.i))
(test-eqv #t (finite? +1.5i))
(test-eqv #f (finite? +inf.0i))
(test-eqv #f (finite? +nan.0i))
(test-eqv #t (finite? 1))
(test-eqv #t (finite? 1+i))
(test-eqv #t (finite? 1+99999999999999999999999999999999i))
(test-eqv #t (finite? 1+1/2i))
(test-eqv #t (finite? 1+0.i))
(test-eqv #t (finite? 1+1.5i))
(test-eqv #f (finite? 1+inf.0i))
(test-eqv #f (finite? 1+nan.0i))
(test-eqv #t (finite? 99999999999999999999999999999999))
(test-eqv #t (finite? 99999999999999999999999999999999+i))
(test-eqv
 #t
 (finite? 99999999999999999999999999999999+99999999999999999999999999999999i))
(test-eqv #t (finite? 99999999999999999999999999999999+1/2i))
(test-eqv #t (finite? 99999999999999999999999999999999+0.i))
(test-eqv #t (finite? 99999999999999999999999999999999+1.5i))
(test-eqv #f (finite? 99999999999999999999999999999999+inf.0i))
(test-eqv #f (finite? 99999999999999999999999999999999+nan.0i))
(test-eqv #t (finite? 1/2))
(test-eqv #t (finite? 1/2+i))
(test-eqv #t (finite? 1/2+99999999999999999999999999999999i))
(test-eqv #t (finite? 1/2+1/2i))
(test-eqv #t (finite? 1/2+0.i))
(test-eqv #t (finite? 1/2+1.5i))
(test-eqv #f (finite? 1/2+inf.0i))
(test-eqv #f (finite? 1/2+nan.0i))
(test-eqv #t (finite? 0.))
(test-eqv #t (finite? 0.+i))
(test-eqv #t (finite? 0.+99999999999999999999999999999999i))
(test-eqv #t (finite? 0.+1/2i))
(test-eqv #t (finite? 0.+0.i))
(test-eqv #t (finite? 0.+1.5i))
(test-eqv #f (finite? 0.+inf.0i))
(test-eqv #f (finite? 0.+nan.0i))
(test-eqv #t (finite? 1.5))
(test-eqv #t (finite? 1.5+i))
(test-eqv #t (finite? 1.5+99999999999999999999999999999999i))
(test-eqv #t (finite? 1.5+1/2i))
(test-eqv #t (finite? 1.5+0.i))
(test-eqv #t (finite? 1.5+1.5i))
(test-eqv #f (finite? 1.5+inf.0i))
(test-eqv #f (finite? 1.5+nan.0i))
(test-eqv #f (finite? +inf.0))
(test-eqv #f (finite? +inf.0+i))
(test-eqv #f (finite? +inf.0+99999999999999999999999999999999i))
(test-eqv #f (finite? +inf.0+1/2i))
(test-eqv #f (finite? +inf.0+0.i))
(test-eqv #f (finite? +inf.0+1.5i))
(test-eqv #f (finite? +inf.0+inf.0i))
(test-eqv #f (finite? +inf.0+nan.0i))
(test-eqv #f (finite? +nan.0))
(test-eqv #f (finite? +nan.0+i))
(test-eqv #f (finite? +nan.0+99999999999999999999999999999999i))
(test-eqv #f (finite? +nan.0+1/2i))
(test-eqv #f (finite? +nan.0+0.i))
(test-eqv #f (finite? +nan.0+1.5i))
(test-eqv #f (finite? +nan.0+inf.0i))
(test-eqv #f (finite? +nan.0+nan.0i))

(test-error-tail type-exception? (infinite? 'a))
(test-eqv #f (infinite? 0))
(test-eqv #f (infinite? 1))
(test-eqv #f (infinite? 99999999999999999999999999999999))
(test-eqv #f (infinite? 1/2))
(test-eqv #f (infinite? 0.))
(test-eqv #f (infinite? 1.5))
(test-eqv #t (infinite? +inf.0))
(test-eqv #f (infinite? +nan.0))
(test-eqv #f (infinite? 0))
(test-eqv #f (infinite? +i))
(test-eqv #f (infinite? +99999999999999999999999999999999i))
(test-eqv #f (infinite? +1/2i))
(test-eqv #f (infinite? +0.i))
(test-eqv #f (infinite? +1.5i))
(test-eqv #t (infinite? +inf.0i))
(test-eqv #f (infinite? +nan.0i))
(test-eqv #f (infinite? 1))
(test-eqv #f (infinite? 1+i))
(test-eqv #f (infinite? 1+99999999999999999999999999999999i))
(test-eqv #f (infinite? 1+1/2i))
(test-eqv #f (infinite? 1+0.i))
(test-eqv #f (infinite? 1+1.5i))
(test-eqv #t (infinite? 1+inf.0i))
(test-eqv #f (infinite? 1+nan.0i))
(test-eqv #f (infinite? 99999999999999999999999999999999))
(test-eqv #f (infinite? 99999999999999999999999999999999+i))
(test-eqv
 #f
 (infinite?
  99999999999999999999999999999999+99999999999999999999999999999999i))
(test-eqv #f (infinite? 99999999999999999999999999999999+1/2i))
(test-eqv #f (infinite? 99999999999999999999999999999999+0.i))
(test-eqv #f (infinite? 99999999999999999999999999999999+1.5i))
(test-eqv #t (infinite? 99999999999999999999999999999999+inf.0i))
(test-eqv #f (infinite? 99999999999999999999999999999999+nan.0i))
(test-eqv #f (infinite? 1/2))
(test-eqv #f (infinite? 1/2+i))
(test-eqv #f (infinite? 1/2+99999999999999999999999999999999i))
(test-eqv #f (infinite? 1/2+1/2i))
(test-eqv #f (infinite? 1/2+0.i))
(test-eqv #f (infinite? 1/2+1.5i))
(test-eqv #t (infinite? 1/2+inf.0i))
(test-eqv #f (infinite? 1/2+nan.0i))
(test-eqv #f (infinite? 0.))
(test-eqv #f (infinite? 0.+i))
(test-eqv #f (infinite? 0.+99999999999999999999999999999999i))
(test-eqv #f (infinite? 0.+1/2i))
(test-eqv #f (infinite? 0.+0.i))
(test-eqv #f (infinite? 0.+1.5i))
(test-eqv #t (infinite? 0.+inf.0i))
(test-eqv #f (infinite? 0.+nan.0i))
(test-eqv #f (infinite? 1.5))
(test-eqv #f (infinite? 1.5+i))
(test-eqv #f (infinite? 1.5+99999999999999999999999999999999i))
(test-eqv #f (infinite? 1.5+1/2i))
(test-eqv #f (infinite? 1.5+0.i))
(test-eqv #f (infinite? 1.5+1.5i))
(test-eqv #t (infinite? 1.5+inf.0i))
(test-eqv #f (infinite? 1.5+nan.0i))
(test-eqv #t (infinite? +inf.0))
(test-eqv #t (infinite? +inf.0+i))
(test-eqv #t (infinite? +inf.0+99999999999999999999999999999999i))
(test-eqv #t (infinite? +inf.0+1/2i))
(test-eqv #t (infinite? +inf.0+0.i))
(test-eqv #t (infinite? +inf.0+1.5i))
(test-eqv #t (infinite? +inf.0+inf.0i))
(test-eqv #f (infinite? +inf.0+nan.0i))
(test-eqv #f (infinite? +nan.0))
(test-eqv #f (infinite? +nan.0+i))
(test-eqv #f (infinite? +nan.0+99999999999999999999999999999999i))
(test-eqv #f (infinite? +nan.0+1/2i))
(test-eqv #f (infinite? +nan.0+0.i))
(test-eqv #f (infinite? +nan.0+1.5i))
(test-eqv #f (infinite? +nan.0+inf.0i))
(test-eqv #f (infinite? +nan.0+nan.0i))

(test-error-tail type-exception? (nan? 'a))
(test-eqv #f (nan? 0))
(test-eqv #f (nan? 1))
(test-eqv #f (nan? 99999999999999999999999999999999))
(test-eqv #f (nan? 1/2))
(test-eqv #f (nan? 0.))
(test-eqv #f (nan? 1.5))
(test-eqv #f (nan? +inf.0))
(test-eqv #t (nan? +nan.0))
(test-eqv #f (nan? 0))
(test-eqv #f (nan? +i))
(test-eqv #f (nan? +99999999999999999999999999999999i))
(test-eqv #f (nan? +1/2i))
(test-eqv #f (nan? +0.i))
(test-eqv #f (nan? +1.5i))
(test-eqv #f (nan? +inf.0i))
(test-eqv #t (nan? +nan.0i))
(test-eqv #f (nan? 1))
(test-eqv #f (nan? 1+i))
(test-eqv #f (nan? 1+99999999999999999999999999999999i))
(test-eqv #f (nan? 1+1/2i))
(test-eqv #f (nan? 1+0.i))
(test-eqv #f (nan? 1+1.5i))
(test-eqv #f (nan? 1+inf.0i))
(test-eqv #t (nan? 1+nan.0i))
(test-eqv #f (nan? 99999999999999999999999999999999))
(test-eqv #f (nan? 99999999999999999999999999999999+i))
(test-eqv
 #f
 (nan? 99999999999999999999999999999999+99999999999999999999999999999999i))
(test-eqv #f (nan? 99999999999999999999999999999999+1/2i))
(test-eqv #f (nan? 99999999999999999999999999999999+0.i))
(test-eqv #f (nan? 99999999999999999999999999999999+1.5i))
(test-eqv #f (nan? 99999999999999999999999999999999+inf.0i))
(test-eqv #t (nan? 99999999999999999999999999999999+nan.0i))
(test-eqv #f (nan? 1/2))
(test-eqv #f (nan? 1/2+i))
(test-eqv #f (nan? 1/2+99999999999999999999999999999999i))
(test-eqv #f (nan? 1/2+1/2i))
(test-eqv #f (nan? 1/2+0.i))
(test-eqv #f (nan? 1/2+1.5i))
(test-eqv #f (nan? 1/2+inf.0i))
(test-eqv #t (nan? 1/2+nan.0i))
(test-eqv #f (nan? 0.))
(test-eqv #f (nan? 0.+i))
(test-eqv #f (nan? 0.+99999999999999999999999999999999i))
(test-eqv #f (nan? 0.+1/2i))
(test-eqv #f (nan? 0.+0.i))
(test-eqv #f (nan? 0.+1.5i))
(test-eqv #f (nan? 0.+inf.0i))
(test-eqv #t (nan? 0.+nan.0i))
(test-eqv #f (nan? 1.5))
(test-eqv #f (nan? 1.5+i))
(test-eqv #f (nan? 1.5+99999999999999999999999999999999i))
(test-eqv #f (nan? 1.5+1/2i))
(test-eqv #f (nan? 1.5+0.i))
(test-eqv #f (nan? 1.5+1.5i))
(test-eqv #f (nan? 1.5+inf.0i))
(test-eqv #t (nan? 1.5+nan.0i))
(test-eqv #f (nan? +inf.0))
(test-eqv #f (nan? +inf.0+i))
(test-eqv #f (nan? +inf.0+99999999999999999999999999999999i))
(test-eqv #f (nan? +inf.0+1/2i))
(test-eqv #f (nan? +inf.0+0.i))
(test-eqv #f (nan? +inf.0+1.5i))
(test-eqv #f (nan? +inf.0+inf.0i))
(test-eqv #t (nan? +inf.0+nan.0i))
(test-eqv #t (nan? +nan.0))
(test-eqv #t (nan? +nan.0+i))
(test-eqv #t (nan? +nan.0+99999999999999999999999999999999i))
(test-eqv #t (nan? +nan.0+1/2i))
(test-eqv #t (nan? +nan.0+0.i))
(test-eqv #t (nan? +nan.0+1.5i))
(test-eqv #t (nan? +nan.0+inf.0i))
(test-eqv #t (nan? +nan.0+nan.0i))

(test-eqv #f (number? 'a))
(test-eqv #t (number? 1+0.i))
(test-eqv #t (number? 1))
(test-eqv #t (number? 11111111111111111111111111111111))
(test-eqv #t (number? 2/3))
(test-eqv #t (number? 1.))
(test-eqv #t (number? +nan.0))
(test-eqv #t (number? +inf.0))
(test-eqv #t (number? -inf.0))

(test-eqv #f (real? 'a))
(test-eqv #f (real? 1+0.i))
(test-eqv #t (real? 1))
(test-eqv #t (real? 11111111111111111111111111111111))
(test-eqv #t (real? 2/3))
(test-eqv #t (real? 1.))
(test-eqv #t (real? +nan.0))
(test-eqv #t (real? +inf.0))
(test-eqv #t (real? -inf.0))

#|

(check-eqv? (? 'a) #f)
(check-eqv? (? +1+0.i) #f)
(check-eqv? (? 1) #t)
(check-eqv? (? 11111111111111111111111111111111) #t)
(check-eqv? (? 2/3) #t)
(check-eqv? (? 1.0) #t)
(check-eqv? (? +nan.0) #t)
(check-eqv? (? +inf.0) #t)
(check-eqv? (? -inf.0) #t)
|#

(test-eqv #f (rational? 'a))
(test-eqv #f (rational? 1+0.i))
(test-eqv #t (rational? 1))
(test-eqv #t (rational? 11111111111111111111111111111111))
(test-eqv #t (rational? 2/3))
(test-eqv #t (rational? 1.))
(test-eqv #f (rational? +nan.0))
(test-eqv #f (rational? +inf.0))
(test-eqv #f (rational? -inf.0))

(test-eqv #f (integer? 'a))
(test-eqv #f (integer? 1+0.i))
(test-eqv #t (integer? 1))
(test-eqv #t (integer? 11111111111111111111111111111111))
(test-eqv #f (integer? 2/3))
(test-eqv #t (integer? 1.))
(test-eqv #f (integer? .5))
(test-eqv #f (integer? +nan.0))
(test-eqv #f (integer? +inf.0))
(test-eqv #f (integer? -inf.0))

(test-error-tail type-exception? (exact? 'a))
(test-eqv #f (exact? 1+0.i))
(test-eqv #t (exact? 1))
(test-eqv #t (exact? 11111111111111111111111111111111))
(test-eqv #t (exact? 2/3))
(test-eqv #f (exact? 1.))
(test-eqv #f (exact? +nan.0))
(test-eqv #f (exact? +inf.0))
(test-eqv #f (exact? -inf.0))

(test-error-tail type-exception? (= 1 'a))
(test-error-tail type-exception? (= 'a 1))
(test-eqv #t (= 1 1+0.i))
(test-eqv #t (= (expt 2. 100) (expt 2 100)))
(test-eqv #t (= (+ 1/3 1/3) 2/3))
(test-eqv #t (= 1. 1))
(test-eqv #f (= +nan.0 1))
(test-eqv #f (let ((x +nan.0)) (= x x)))
(test-eqv #t (= +inf.0 +inf.0))
(test-eqv #t (= -inf.0 -inf.0))
(test-eqv #t (= (- +inf.0) -inf.0))

(test-error-tail type-exception? (= 1 'a))
(test-error-tail type-exception? (= 'a 1))
(test-eqv 2 (+ 1 1))
(test-eqv
 (* 3 (- (quotient (##least-fixnum) 2)))
 (let ((x (- (* 3 (quotient (##least-fixnum) 4))))) (+ x x)))

(test-error-tail type-exception? (square 'a))
(test-eqv 9 (square 3))
(test-eqv (expt 2 2000) (square (expt 2 1000)))
(test-eqv 4/9 (square 2/3))
(test-eqv .0625 (square .25))
(test-approximate .046875+.0625i (square .25+.125i) 1e-12)
(test-eqv 0.+inf.0i (square +inf.0+inf.0i))

(test-error-tail type-exception? (sqrt 'a))
(test-eqv 4 (sqrt 16))
(test-eqv (expt 3 50) (sqrt (expt 3 100)))
(test-eqv 2/3 (sqrt 4/9))
(test-eqv 2. (sqrt 4.))
(test-eqv 1.+1.i (sqrt +2.i))
(test-eqv 1.-1.i (sqrt -2.i))
(test-eqv (expt 2. 500) (sqrt (+ (expt 2 1000) 1)))
(test-eqv 2.05891132094649e14 (sqrt (+ (expt 3 60) 1)))
;; The following argument exercises the (##fxnegative? r)
;; code path in ##exact-int.sqrt for 64-bit fixnums.
(test-eqv 421816537 (integer-sqrt 177929191730305443))

(test-error-tail type-exception? (abs 'a))
(test-eqv 1 (abs -1))
(test-eqv 1 (abs 1))
(test-eqv (expt 3 100) (abs (- (expt 3 100))))
(test-eqv (expt 3 100) (abs (expt 3 100)))
(test-eqv 2/3 (abs 2/3))
(test-eqv 2/3 (abs -2/3))
(test-eqv 1. (abs -1.))
(test-eqv 1. (abs 1.))
(test-error-tail type-exception? (abs 12.+5.i))
(test-error-tail type-exception? (abs 12+5i))

(test-error-tail type-exception? (magnitude 'a))
(test-eqv 1 (magnitude -1))
(test-eqv 1 (magnitude 1))
(test-eqv (expt 3 100) (magnitude (- (expt 3 100))))
(test-eqv (expt 3 100) (magnitude (expt 3 100)))
(test-eqv 2/3 (magnitude 2/3))
(test-eqv 2/3 (magnitude -2/3))
(test-eqv 1. (magnitude -1.))
(test-eqv 1. (magnitude 1.))
(test-eqv 13. (magnitude 12.+5.i))
(test-eqv 13 (magnitude 12+5i))

(test-eqv (* 10000 (log 2)) (log (expt 2 10000)))
(test-eqv +inf.0+0.i (log +inf.0+0.i))
(test-eqv (+ +inf.0 (log -1.)) (log -inf.0+0.i))

(test-eqv +nan.0 (atan +nan.0 0))
(test-eqv +nan.0 (atan 0 +nan.0))
(test-eqv (macro-inexact-+pi/2) (atan 2 0))
(test-eqv (macro-inexact-+pi/4) (atan +inf.0 +inf.0))
(test-eqv (- (macro-inexact-+pi/4)) (atan -inf.0 +inf.0))
(test-eqv (macro-inexact-+pi/4) (atan (expt 3 10000) (expt 3 10000)))

(test-eqv +2i (expt -4 1/2))
(test-eqv +2.i (expt -4. 1/2))
(test-eqv -8i (expt -4 3/2))
(test-eqv -8.i (expt -4. 3/2))
(test-eqv (* 2 (macro-cpxnum-+1/2+sqrt3/2i)) (expt -8 1/3))
(test-eqv (* 4 (macro-cpxnum--1/2+sqrt3/2i)) (expt -8 2/3))
(test-eqv (* 16 (macro-cpxnum--1/2-sqrt3/2i)) (expt -8 4/3))
(test-eqv (* 32 (macro-cpxnum-+1/2-sqrt3/2i)) (expt -8 5/3))
(test-eqv (* 2 (macro-cpxnum-+sqrt3/2+1/2i)) (expt -64 1/6))
(test-eqv (* 32 (macro-cpxnum--sqrt3/2+1/2i)) (expt -64 5/6))
(test-eqv (* 128 (macro-cpxnum--sqrt3/2-1/2i)) (expt -64 7/6))
(test-eqv (* 2048 (macro-cpxnum-+sqrt3/2-1/2i)) (expt -64 11/6))
(test-eqv (/ (sqrt (sqrt 100))) (expt 100 -1/4))

;; On Windows with 32 bit MinGW, the following unit tests fail:
;;
;;(check-eqv? (expt 100/81 -1/4) (/ 3 (sqrt (sqrt 100))))
;;(check-eqv? (expt -1. (expt 3 1000)) -1.)
;;
;; They give these errors:
;;
;;"unit-tests\\04-coverage\\_num.scm"@174.1: FAILED (check-eqv? (expt 100/81 -1/4) (/ 3 (sqrt (sqrt 100)))) GOT .9486832980505139
;;"unit-tests\\04-coverage\\_num.scm"@175.1: FAILED (check-eqv? (expt -1. (expt 3 1000)) -1.) GOT +nan.0
;;
;; The problem occurs specifically in the appveyor environment.
;; Unfortunately it can't be reproduced elsewhere, so solving
;; this issue will have to wait until the issue appears in a
;; debugging environment we have access to.

(test-eqv 3/2 (expt 27/8 1/3))
(test-eqv -2+2i (expt +2i 3/2))
(test-eqv 1+i (expt +2i 1/2))
(test-error-tail range-exception? (expt 0 -1+i))
(test-error-tail range-exception? (expt 0 -3/4))

(test-error-tail type-exception? (bitwise-and 1 'a))
(test-error-tail type-exception? (bitwise-and 'a 1))
(test-eqv (test-bitwise-and 123443 17042360) (bitwise-and 123443 17042360))
(test-eqv
 (test-bitwise-and 123443 902345798234656542928345617042360)
 (bitwise-and 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-and -123443 17042360) (bitwise-and -123443 17042360))
(test-eqv
 (test-bitwise-and -123443 902345798234656542928345617042360)
 (bitwise-and -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-and 123443 -17042360) (bitwise-and 123443 -17042360))
(test-eqv
 (test-bitwise-and 123443 -902345798234656542928345617042360)
 (bitwise-and 123443 -902345798234656542928345617042360))
(test-eqv (test-bitwise-and -123443 -17042360) (bitwise-and -123443 -17042360))
(test-eqv
 (test-bitwise-and -123443 -902345798234656542928345617042360)
 (bitwise-and -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-and
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-and 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-and
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-and -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-and
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-and 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-and
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-and -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-and 902345798234656542928345617042360 123443)
 (bitwise-and 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-andc1 1 'a))
(test-error-tail type-exception? (bitwise-andc1 'a 1))
(test-eqv (test-bitwise-andc1 123443 17042360) (bitwise-andc1 123443 17042360))
(test-eqv
 (test-bitwise-andc1 123443 902345798234656542928345617042360)
 (bitwise-andc1 123443 902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc1 -123443 17042360)
 (bitwise-andc1 -123443 17042360))
(test-eqv
 (test-bitwise-andc1 -123443 902345798234656542928345617042360)
 (bitwise-andc1 -123443 902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc1 123443 -17042360)
 (bitwise-andc1 123443 -17042360))
(test-eqv
 (test-bitwise-andc1 123443 -902345798234656542928345617042360)
 (bitwise-andc1 123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc1 -123443 -17042360)
 (bitwise-andc1 -123443 -17042360))
(test-eqv
 (test-bitwise-andc1 -123443 -902345798234656542928345617042360)
 (bitwise-andc1 -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc1
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-andc1 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc1
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-andc1 -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc1
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-andc1 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc1
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-andc1
  -34572348562304523465432065423
  -234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc1 902345798234656542928345617042360 123443)
 (bitwise-andc1 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-andc2 1 'a))
(test-error-tail type-exception? (bitwise-andc2 'a 1))
(test-eqv (test-bitwise-andc2 123443 17042360) (bitwise-andc2 123443 17042360))
(test-eqv
 (test-bitwise-andc2 123443 902345798234656542928345617042360)
 (bitwise-andc2 123443 902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc2 -123443 17042360)
 (bitwise-andc2 -123443 17042360))
(test-eqv
 (test-bitwise-andc2 -123443 902345798234656542928345617042360)
 (bitwise-andc2 -123443 902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc2 123443 -17042360)
 (bitwise-andc2 123443 -17042360))
(test-eqv
 (test-bitwise-andc2 123443 -902345798234656542928345617042360)
 (bitwise-andc2 123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc2 -123443 -17042360)
 (bitwise-andc2 -123443 -17042360))
(test-eqv
 (test-bitwise-andc2 -123443 -902345798234656542928345617042360)
 (bitwise-andc2 -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-andc2
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-andc2 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc2
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-andc2 -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc2
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-andc2 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc2
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-andc2
  -34572348562304523465432065423
  -234532485620943562345234958634))
(test-eqv
 (test-bitwise-andc2 902345798234656542928345617042360 123443)
 (bitwise-andc2 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-eqv 1 'a))
(test-error-tail type-exception? (bitwise-eqv 'a 1))
(test-eqv (test-bitwise-eqv 123443 17042360) (bitwise-eqv 123443 17042360))
(test-eqv
 (test-bitwise-eqv 123443 902345798234656542928345617042360)
 (bitwise-eqv 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-eqv -123443 17042360) (bitwise-eqv -123443 17042360))
(test-eqv
 (test-bitwise-eqv -123443 902345798234656542928345617042360)
 (bitwise-eqv -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-eqv 123443 -17042360) (bitwise-eqv 123443 -17042360))
(test-eqv
 (test-bitwise-eqv 123443 -902345798234656542928345617042360)
 (bitwise-eqv 123443 -902345798234656542928345617042360))
(test-eqv (test-bitwise-eqv -123443 -17042360) (bitwise-eqv -123443 -17042360))
(test-eqv
 (test-bitwise-eqv -123443 -902345798234656542928345617042360)
 (bitwise-eqv -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-eqv
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-eqv 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-eqv
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-eqv -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-eqv
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-eqv 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-eqv
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-eqv -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-eqv 902345798234656542928345617042360 123443)
 (bitwise-eqv 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-ior 1 'a))
(test-error-tail type-exception? (bitwise-ior 'a 1))
(test-eqv (test-bitwise-ior 123443 17042360) (bitwise-ior 123443 17042360))
(test-eqv
 (test-bitwise-ior 123443 902345798234656542928345617042360)
 (bitwise-ior 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-ior -123443 17042360) (bitwise-ior -123443 17042360))
(test-eqv
 (test-bitwise-ior -123443 902345798234656542928345617042360)
 (bitwise-ior -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-ior 123443 -17042360) (bitwise-ior 123443 -17042360))
(test-eqv
 (test-bitwise-ior 123443 -902345798234656542928345617042360)
 (bitwise-ior 123443 -902345798234656542928345617042360))
(test-eqv (test-bitwise-ior -123443 -17042360) (bitwise-ior -123443 -17042360))
(test-eqv
 (test-bitwise-ior -123443 -902345798234656542928345617042360)
 (bitwise-ior -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-ior
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-ior 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-ior
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-ior -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-ior
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-ior 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-ior
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-ior -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-ior 902345798234656542928345617042360 123443)
 (bitwise-ior 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-nand 1 'a))
(test-error-tail type-exception? (bitwise-nand 'a 1))
(test-eqv (test-bitwise-nand 123443 17042360) (bitwise-nand 123443 17042360))
(test-eqv
 (test-bitwise-nand 123443 902345798234656542928345617042360)
 (bitwise-nand 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-nand -123443 17042360) (bitwise-nand -123443 17042360))
(test-eqv
 (test-bitwise-nand -123443 902345798234656542928345617042360)
 (bitwise-nand -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-nand 123443 -17042360) (bitwise-nand 123443 -17042360))
(test-eqv
 (test-bitwise-nand 123443 -902345798234656542928345617042360)
 (bitwise-nand 123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-nand -123443 -17042360)
 (bitwise-nand -123443 -17042360))
(test-eqv
 (test-bitwise-nand -123443 -902345798234656542928345617042360)
 (bitwise-nand -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-nand
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-nand 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-nand
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-nand -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-nand
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-nand 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-nand
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-nand -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-nand 902345798234656542928345617042360 123443)
 (bitwise-nand 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-nor 1 'a))
(test-error-tail type-exception? (bitwise-nor 'a 1))
(test-eqv (test-bitwise-nor 123443 17042360) (bitwise-nor 123443 17042360))
(test-eqv
 (test-bitwise-nor 123443 902345798234656542928345617042360)
 (bitwise-nor 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-nor -123443 17042360) (bitwise-nor -123443 17042360))
(test-eqv
 (test-bitwise-nor -123443 902345798234656542928345617042360)
 (bitwise-nor -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-nor 123443 -17042360) (bitwise-nor 123443 -17042360))
(test-eqv
 (test-bitwise-nor 123443 -902345798234656542928345617042360)
 (bitwise-nor 123443 -902345798234656542928345617042360))
(test-eqv (test-bitwise-nor -123443 -17042360) (bitwise-nor -123443 -17042360))
(test-eqv
 (test-bitwise-nor -123443 -902345798234656542928345617042360)
 (bitwise-nor -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-nor
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-nor 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-nor
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-nor -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-nor
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-nor 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-nor
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-nor -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-nor 902345798234656542928345617042360 123443)
 (bitwise-nor 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-not 'a))
(test-eqv (test-bitwise-not 17042360) (bitwise-not 17042360))
(test-eqv (test-bitwise-not -123443) (bitwise-not -123443))
(test-eqv
 (test-bitwise-not 902345798234656542928345617042360)
 (bitwise-not 902345798234656542928345617042360))
(test-eqv
 (test-bitwise-not -902345798234656542928345617042360)
 (bitwise-not -902345798234656542928345617042360))

(test-error-tail type-exception? (bitwise-orc1 1 'a))
(test-error-tail type-exception? (bitwise-orc1 'a 1))
(test-eqv (test-bitwise-orc1 123443 17042360) (bitwise-orc1 123443 17042360))
(test-eqv
 (test-bitwise-orc1 123443 902345798234656542928345617042360)
 (bitwise-orc1 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-orc1 -123443 17042360) (bitwise-orc1 -123443 17042360))
(test-eqv
 (test-bitwise-orc1 -123443 902345798234656542928345617042360)
 (bitwise-orc1 -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-orc1 123443 -17042360) (bitwise-orc1 123443 -17042360))
(test-eqv
 (test-bitwise-orc1 123443 -902345798234656542928345617042360)
 (bitwise-orc1 123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-orc1 -123443 -17042360)
 (bitwise-orc1 -123443 -17042360))
(test-eqv
 (test-bitwise-orc1 -123443 -902345798234656542928345617042360)
 (bitwise-orc1 -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-orc1
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-orc1 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc1
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-orc1 -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc1
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-orc1 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc1
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-orc1 -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc1 902345798234656542928345617042360 123443)
 (bitwise-orc1 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-orc2 1 'a))
(test-error-tail type-exception? (bitwise-orc2 'a 1))
(test-eqv (test-bitwise-orc2 123443 17042360) (bitwise-orc2 123443 17042360))
(test-eqv
 (test-bitwise-orc2 123443 902345798234656542928345617042360)
 (bitwise-orc2 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-orc2 -123443 17042360) (bitwise-orc2 -123443 17042360))
(test-eqv
 (test-bitwise-orc2 -123443 902345798234656542928345617042360)
 (bitwise-orc2 -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-orc2 123443 -17042360) (bitwise-orc2 123443 -17042360))
(test-eqv
 (test-bitwise-orc2 123443 -902345798234656542928345617042360)
 (bitwise-orc2 123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-orc2 -123443 -17042360)
 (bitwise-orc2 -123443 -17042360))
(test-eqv
 (test-bitwise-orc2 -123443 -902345798234656542928345617042360)
 (bitwise-orc2 -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-orc2
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-orc2 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc2
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-orc2 -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc2
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-orc2 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc2
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-orc2 -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-orc2 902345798234656542928345617042360 123443)
 (bitwise-orc2 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bitwise-xor 1 'a))
(test-error-tail type-exception? (bitwise-xor 'a 1))
(test-eqv (test-bitwise-xor 123443 17042360) (bitwise-xor 123443 17042360))
(test-eqv
 (test-bitwise-xor 123443 902345798234656542928345617042360)
 (bitwise-xor 123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-xor -123443 17042360) (bitwise-xor -123443 17042360))
(test-eqv
 (test-bitwise-xor -123443 902345798234656542928345617042360)
 (bitwise-xor -123443 902345798234656542928345617042360))
(test-eqv (test-bitwise-xor 123443 -17042360) (bitwise-xor 123443 -17042360))
(test-eqv
 (test-bitwise-xor 123443 -902345798234656542928345617042360)
 (bitwise-xor 123443 -902345798234656542928345617042360))
(test-eqv (test-bitwise-xor -123443 -17042360) (bitwise-xor -123443 -17042360))
(test-eqv
 (test-bitwise-xor -123443 -902345798234656542928345617042360)
 (bitwise-xor -123443 -902345798234656542928345617042360))
(test-eqv
 (test-bitwise-xor
  34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-xor 34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-xor
  -34572348562304523465432065423
  234532485620943562345234958634)
 (bitwise-xor -34572348562304523465432065423 234532485620943562345234958634))
(test-eqv
 (test-bitwise-xor
  34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-xor 34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-xor
  -34572348562304523465432065423
  -234532485620943562345234958634)
 (bitwise-xor -34572348562304523465432065423 -234532485620943562345234958634))
(test-eqv
 (test-bitwise-xor 902345798234656542928345617042360 123443)
 (bitwise-xor 902345798234656542928345617042360 123443))

(test-error-tail type-exception? (bits 123))
(test-error-tail type-exception? (bits "foo"))
(test-eqv 0 (bits))
(test-eqv 0 (bits #f))
(test-eqv 1 (bits #t))
(test-eqv 10 (bits #f #t #f #t))

(test-error-tail type-exception? (list->bits "foo"))
(test-error-tail type-exception? (list->bits '(123)))
(test-error-tail type-exception? (list->bits '("foo")))
(test-error-tail type-exception? (list->bits '(#f . #f)))
(test-eqv 0 (list->bits '()))
(test-eqv 0 (list->bits '(#f)))
(test-eqv 1 (list->bits '(#t)))
(test-eqv 7 (list->bits '(#t #t #t #f)))
(test-eqv 10 (list->bits '(#f #t #f #t)))

(test-error-tail type-exception? (vector->bits "foo"))
(test-error-tail type-exception? (vector->bits '#(123)))
(test-error-tail type-exception? (vector->bits '#("foo")))
(test-eqv 0 (vector->bits '#()))
(test-eqv 0 (vector->bits '#(#f)))
(test-eqv 1 (vector->bits '#(#t)))
(test-eqv 7 (vector->bits '#(#t #t #t #f)))
(test-eqv 10 (vector->bits '#(#f #t #f #t)))

(test-error-tail type-exception? (bits->vector "foo"))
(test-error-tail type-exception? (bits->vector 10 "foo"))
(test-equal '#(#t #t #t #f) (bits->vector -9))
(test-equal '#() (bits->vector -1))
(test-equal '#() (bits->vector 0))
(test-equal '#(#t) (bits->vector 1))
(test-equal '#(#f #t #f #t) (bits->vector 10))
(test-equal '#(#t #t #t) (bits->vector -9 3))
(test-equal '#(#t #t #t) (bits->vector -1 3))
(test-equal '#(#f #f #f) (bits->vector 0 3))
(test-equal '#(#t #f #f) (bits->vector 1 3))
(test-equal '#(#f #t #f) (bits->vector 10 3))

(test-error-tail type-exception? (bits->list "foo"))
(test-error-tail type-exception? (bits->list 10 "foo"))
(test-equal '(#t #t #t #f) (bits->list -9))
(test-equal '() (bits->list -1))
(test-equal '() (bits->list 0))
(test-equal '(#t) (bits->list 1))
(test-equal '(#f #t #f #t) (bits->list 10))
(test-equal '(#t #t #t) (bits->list -9 3))
(test-equal '(#t #t #t) (bits->list -1 3))
(test-equal '(#f #f #f) (bits->list 0 3))
(test-equal '(#t #f #f) (bits->list 1 3))
(test-equal '(#f #t #f) (bits->list 10 3))

;;;------------------------------------------------------------
;;; Minimal new tests for the remainder of SRFI 151 routines
;;;------------------------------------------------------------

(test-error-tail type-exception? (bitwise-if 'a 3 2))
(test-error-tail type-exception? (bitwise-if 2 'a 3))
(test-error-tail type-exception? (bitwise-if 2 2 'a))
(test-eqv 9 (bitwise-if 3 1 8))
(test-eqv 0 (bitwise-if 3 8 1))
(test-eqv 3 (bitwise-if 1 1 2))
(test-eqv 51 (bitwise-if 60 240 15))

(test-error-tail type-exception? (copy-bit 0 0 'a))
(test-error-tail type-exception? (copy-bit 0 'a #f))
(test-error-tail type-exception? (copy-bit 'a -1 #f))
(test-error-tail range-exception? (copy-bit -1 -1 #f))
(test-eqv 0 (copy-bit 0 0 #f))
(test-eqv 0 (copy-bit 30 0 #f))
(test-eqv 0 (copy-bit 31 0 #f))
(test-eqv 0 (copy-bit 62 0 #f))
(test-eqv 0 (copy-bit 63 0 #f))
(test-eqv 0 (copy-bit 128 0 #f))
(test-eqv -1 (copy-bit 0 -1 #t))
(test-eqv -1 (copy-bit 30 -1 #t))
(test-eqv -1 (copy-bit 31 -1 #t))
(test-eqv -1 (copy-bit 62 -1 #t))
(test-eqv -1 (copy-bit 63 -1 #t))
(test-eqv -1 (copy-bit 128 -1 #t))
(test-eqv 1 (copy-bit 0 0 #t))
(test-eqv 262 (copy-bit 8 6 #t))
(test-eqv 6 (copy-bit 8 6 #f))
(test-eqv -2 (copy-bit 0 -1 #f))
(test-eqv 0 (copy-bit 128 340282366920938463463374607431768211456 #f))
(test-eqv
 340282366920938463463374607431768211456
 (copy-bit 128 340282366920938463463374607431768211456 #t))
(test-eqv
 340282366920938463463374607431768211456
 (copy-bit 64 340282366920938463463374607431768211456 #f))
(test-eqv
 -340282366920938463463374607431768211456
 (copy-bit 64 -340282366920938463463374607431768211456 #f))
(test-eqv
 -340282366920938463463374607431768211456
 (copy-bit 256 -340282366920938463463374607431768211456 #t))
(test-eqv 4 (copy-bit 2 0 #t))
(test-eqv 11 (copy-bit 2 15 #f))
(test-eqv 1 (copy-bit 0 0 #t))

(test-error-tail type-exception? (bit-swap 1 2 'a))
(test-error-tail type-exception? (bit-swap 1 'a -1))
(test-error-tail range-exception? (bit-swap 1 -1 -1))
(test-error-tail type-exception? (bit-swap 'a 1 -1))
(test-error-tail range-exception? (bit-swap -1 1 -1))
(test-eqv 11 (bit-swap 1 2 13))
(test-eqv 11 (bit-swap 2 1 13))
(test-eqv 14 (bit-swap 0 1 13))
(test-eqv 1029 (bit-swap 3 10 13))
(test-eqv 1 (bit-swap 0 2 4))

(test-error-tail type-exception? (any-bit-set? 'a 6))
(test-error-tail type-exception? (any-bit-set? 6 'a))
(test-eqv #t (any-bit-set? 3 6))
(test-eqv #f (any-bit-set? 3 12))
(test-eqv #t (every-bit-set? 4 6))
(test-eqv #f (every-bit-set? 7 6))

(test-error-tail type-exception? (every-bit-set? 'a 6))
(test-error-tail type-exception? (every-bit-set? 6 'a))
(test-eqv #t (every-bit-set? 4 6))
(test-eqv #f (every-bit-set? 7 6))

(test-error-tail type-exception? (bit-field 6 0 'a))
(test-error-tail type-exception? (bit-field 6 'a 1))
(test-error-tail type-exception? (bit-field 'a 0 1))
(test-error-tail range-exception? (bit-field 6 0 -1))
(test-error-tail range-exception? (bit-field 6 -1 1))
(test-error-tail range-exception? (bit-field 6 2 1))
(test-eqv 0 (bit-field 6 0 1))
(test-eqv 3 (bit-field 6 1 3))
(test-eqv 1 (bit-field 6 2 999))
(test-eqv 1 (bit-field 340282366920938463463374607431768211456 128 129))
(test-eqv 10 (bit-field 874 0 4))
(test-eqv 45 (bit-field 874 3 9))
(test-eqv 22 (bit-field 874 4 9))
(test-eqv 54 (bit-field 874 4 10))

(test-error-tail type-exception? (bit-field-any? 6 0 'a))
(test-error-tail type-exception? (bit-field-any? 6 'a 1))
(test-error-tail type-exception? (bit-field-any? 'a 0 1))
(test-error-tail range-exception? (bit-field-any? 6 0 -1))
(test-error-tail range-exception? (bit-field-any? 6 -1 1))
(test-error-tail range-exception? (bit-field-any? 6 2 1))
(test-eqv #t (bit-field-any? 45 0 2))
(test-eqv #t (bit-field-any? 45 2 4))
(test-eqv #f (bit-field-any? 45 1 2))


(test-error-tail type-exception? (bit-field-every? 6 0 'a))
(test-error-tail type-exception? (bit-field-every? 6 'a 1))
(test-error-tail type-exception? (bit-field-every? 'a 0 1))
(test-error-tail range-exception? (bit-field-every? 6 0 -1))
(test-error-tail range-exception? (bit-field-every? 6 -1 1))
(test-error-tail range-exception? (bit-field-every? 6 2 1))
(test-eqv #f (bit-field-every? 45 0 2))
(test-eqv #t (bit-field-every? 45 2 4))
(test-eqv #t (bit-field-every? 45 0 1))


(test-error-tail type-exception? (bit-field-clear 6 0 'a))
(test-error-tail type-exception? (bit-field-clear 6 'a 1))
(test-error-tail type-exception? (bit-field-clear 'a 0 1))
(test-error-tail range-exception? (bit-field-clear 6 0 -1))
(test-error-tail range-exception? (bit-field-clear 6 -1 1))
(test-error-tail range-exception? (bit-field-clear 6 2 1))
(test-eqv 32 (bit-field-clear 42 1 4))

(test-error-tail type-exception? (bit-field-set 6 0 'a))
(test-error-tail type-exception? (bit-field-set 6 'a 1))
(test-error-tail type-exception? (bit-field-set 'a 0 1))
(test-error-tail range-exception? (bit-field-set 6 0 -1))
(test-error-tail range-exception? (bit-field-set 6 -1 1))
(test-error-tail range-exception? (bit-field-set 6 2 1))
(test-eqv 46 (bit-field-set 42 1 4))

(test-error-tail type-exception? (bit-field-replace 'a 1 0 1))
(test-error-tail type-exception? (bit-field-replace 6 'a 0 1))
(test-error-tail type-exception? (bit-field-replace 6 1 'a 1))
(test-error-tail type-exception? (bit-field-replace 6 1 0 'a))
(test-error-tail range-exception? (bit-field-replace 6 1 -1 1))
(test-error-tail range-exception? (bit-field-replace 6 1 0 -1))
(test-error-tail range-exception? (bit-field-replace 6 1 2 1))
(test-eqv 7 (bit-field-replace 6 1 0 1))
(test-eqv 6 (bit-field-replace 6 1 1 2))
(test-eqv 2 (bit-field-replace 6 1 1 3))
(test-eqv 36 (bit-field-replace 42 2 1 4))

(test-error-tail type-exception? (bit-field-replace-same 'a 1 0 1))
(test-error-tail type-exception? (bit-field-replace-same 6 'a 0 1))
(test-error-tail type-exception? (bit-field-replace-same 6 1 'a 1))
(test-error-tail type-exception? (bit-field-replace-same 6 1 0 'a))
(test-error-tail range-exception? (bit-field-replace-same 6 1 -1 1))
(test-error-tail range-exception? (bit-field-replace-same 6 1 0 -1))
(test-error-tail range-exception? (bit-field-replace-same 6 1 2 1))
(test-eqv 9 (bit-field-replace-same 15 0 1 3))


(test-error-tail type-exception? (bit-field-rotate 'a 0 0 10))
(test-error-tail type-exception? (bit-field-rotate 6 'a 0 10))
(test-error-tail type-exception? (bit-field-rotate 6 0 'a 10))
(test-error-tail type-exception? (bit-field-rotate 6 0 0 'a))
(test-error-tail range-exception? (bit-field-rotate 6 0 -1 10))
(test-error-tail range-exception? (bit-field-rotate 6 0 0 -1))
(test-error-tail range-exception? (bit-field-rotate 6 0 2 1))
(test-eqv 6 (bit-field-rotate 6 0 0 10))
(test-eqv 6 (bit-field-rotate 6 0 0 256))
(test-eqv 1 (bit-field-rotate 340282366920938463463374607431768211456 1 0 129))
(test-eqv 6 (bit-field-rotate 6 1 1 2))
(test-eqv 10 (bit-field-rotate 6 1 2 4))
(test-eqv 11 (bit-field-rotate 7 -1 1 4))


(test-error-tail type-exception? (bit-field-reverse 'a 1 4))
(test-error-tail type-exception? (bit-field-reverse 6 'a 4))
(test-error-tail type-exception? (bit-field-reverse 6 1 'a))
(test-error-tail range-exception? (bit-field-reverse 6 -1 3))
(test-error-tail range-exception? (bit-field-reverse 6 1 -1))
(test-error-tail range-exception? (bit-field-reverse 6 3 1))
(test-eqv 6 (bit-field-reverse 6 1 3))
(test-eqv 12 (bit-field-reverse 6 1 4))
(test-eqv 2147483648 (bit-field-reverse 1 0 32))
(test-eqv 1073741824 (bit-field-reverse 1 0 31))
(test-eqv 536870912 (bit-field-reverse 1 0 30))
(test-eqv 5 (bit-field-reverse 425352958651173079329218259289710264320 0 129))

(test-error-tail type-exception? (bitwise-fold 'a '() 87))
(test-error-tail type-exception? (bitwise-fold cons '() 'a))
(test-equal '(#t #f #t #f #t #t #t) (bitwise-fold cons '() 87))

(test-error-tail type-exception? (bitwise-for-each 'a 87))
(test-error-tail type-exception? (bitwise-for-each (lambda (b) #t) 'a))
(test-eqv
 5
 (let ((count 0))
   (bitwise-for-each (lambda (b) (if b (set! count (+ count 1)))) 87)
   count))

(test-error-tail
 type-exception?
 (bitwise-unfold 'a even? (lambda (i) (+ i 1)) 0))
(test-error-tail
 type-exception?
 (bitwise-unfold (lambda (i) (= i 10)) 'a (lambda (i) (+ i 1)) 0))
(test-error-tail
 type-exception?
 (bitwise-unfold (lambda (i) (= i 10)) even? 'a 0))
(test-eqv
 341
 (bitwise-unfold (lambda (i) (= i 10)) even? (lambda (i) (+ i 1)) 0))

(test-error-tail type-exception? (make-bitwise-generator 1.))
(let ((g (make-bitwise-generator 6)))
  (test-eqv #f (g))
  (test-eqv #t (g))
  (test-eqv #t (g))
  (test-eqv #f (g)))

;;;------------------------------------------------------------
;;; End of tests for the remainder of SRFI 151 routines
;;;------------------------------------------------------------

(if (##use-fast-bignum-algorithms?)
    (test-eqv (* (expt 3 1000000) (expt 5 1000000)) (expt 15 1000000)))

(test-eqv 2 (+ 1 1))
(test-eqv
 1267650600228229401496703205377
 (+ 1 1267650600228229401496703205376))
(test-eqv 3/2 (+ 1 1/2))
(test-eqv 2. (+ 1 1.))
(test-eqv 2+i (+ 1 1+i))
(test-eqv
 1267650600228229401496703205377
 (+ 1267650600228229401496703205376 1))
(test-eqv
 2535301200456458802993406410752
 (+ 1267650600228229401496703205376 1267650600228229401496703205376))
(test-eqv
 2535301200456458802993406410753/2
 (+ 1267650600228229401496703205376 1/2))
(test-eqv 1.2676506002282294e30 (+ 1267650600228229401496703205376 1.))
(test-eqv
 1267650600228229401496703205377+i
 (+ 1267650600228229401496703205376 1+i))
(test-eqv 3/2 (+ 1/2 1))
(test-eqv
 2535301200456458802993406410753/2
 (+ 1/2 1267650600228229401496703205376))
(test-eqv 1 (+ 1/2 1/2))
(test-eqv 1.5 (+ 1/2 1.))
(test-eqv 3/2+i (+ 1/2 1+i))
(test-eqv 2. (+ 1. 1))
(test-eqv 1.2676506002282294e30 (+ 1. 1267650600228229401496703205376))
(test-eqv 1.5 (+ 1. 1/2))
(test-eqv 2. (+ 1. 1.))
(test-eqv 2.+i (+ 1. 1+i))
(test-eqv 2+i (+ 1+i 1))
(test-eqv
 1267650600228229401496703205377+i
 (+ 1+i 1267650600228229401496703205376))
(test-eqv 3/2+i (+ 1+i 1/2))
(test-eqv 2.+i (+ 1+i 1.))
(test-eqv 2+2i (+ 1+i 1+i))
(if (eqv? 0 (* 0 0.))
    ;; These tests exercise (macro-special-case-exact-zero?)
    (begin (test-eqv -0.i (+ -0.i 0)) (test-eqv -0. (+ 0 -0.))))

(test-eqv 0 (- 1 1))
(test-eqv
 -1267650600228229401496703205375
 (- 1 1267650600228229401496703205376))
(test-eqv 1/2 (- 1 1/2))
(test-eqv 0. (- 1 1.))
(test-eqv -i (- 1 1+i))
(test-eqv
 1267650600228229401496703205375
 (- 1267650600228229401496703205376 1))
(test-eqv
 0
 (- 1267650600228229401496703205376 1267650600228229401496703205376))
(test-eqv
 2535301200456458802993406410751/2
 (- 1267650600228229401496703205376 1/2))
(test-eqv 1.2676506002282294e30 (- 1267650600228229401496703205376 1.))
(test-eqv
 1267650600228229401496703205375-i
 (- 1267650600228229401496703205376 1+i))
(test-eqv -1/2 (- 1/2 1))
(test-eqv
 -2535301200456458802993406410751/2
 (- 1/2 1267650600228229401496703205376))
(test-eqv 0 (- 1/2 1/2))
(test-eqv -.5 (- 1/2 1.))
(test-eqv -1/2-i (- 1/2 1+i))
(test-eqv 0. (- 1. 1))
(test-eqv -1.2676506002282294e30 (- 1. 1267650600228229401496703205376))
(test-eqv .5 (- 1. 1/2))
(test-eqv 0. (- 1. 1.))
(test-eqv 0.-i (- 1. 1+i))
(test-eqv +i (- 1+i 1))
(test-eqv
 -1267650600228229401496703205375+i
 (- 1+i 1267650600228229401496703205376))
(test-eqv 1/2+i (- 1+i 1/2))
(test-eqv 0.+i (- 1+i 1.))
(test-eqv 0 (- 1+i 1+i))

(test-eqv 1 (* 1 1))
(test-eqv
 1267650600228229401496703205376
 (* 1 1267650600228229401496703205376))
(test-eqv 1/2 (* 1 1/2))
(test-eqv 1. (* 1 1.))
(test-eqv 1+i (* 1 1+i))
(test-eqv
 1267650600228229401496703205376
 (* 1267650600228229401496703205376 1))
(test-eqv
 1606938044258990275541962092341162602522202993782792835301376
 (* 1267650600228229401496703205376 1267650600228229401496703205376))
(test-eqv
 633825300114114700748351602688
 (* 1267650600228229401496703205376 1/2))
(test-eqv 1.2676506002282294e30 (* 1267650600228229401496703205376 1.))
(test-eqv
 1267650600228229401496703205376+1267650600228229401496703205376i
 (* 1267650600228229401496703205376 1+i))
(test-eqv 1/2 (* 1/2 1))
(test-eqv
 633825300114114700748351602688
 (* 1/2 1267650600228229401496703205376))
(test-eqv 1/4 (* 1/2 1/2))
(test-eqv .5 (* 1/2 1.))
(test-eqv 1/2+1/2i (* 1/2 1+i))
(test-eqv 1. (* 1. 1))
(test-eqv 1.2676506002282294e30 (* 1. 1267650600228229401496703205376))
(test-eqv .5 (* 1. 1/2))
(test-eqv 1. (* 1. 1.))
(test-eqv 1.+1.i (* 1. 1+i))
(test-eqv 1+i (* 1+i 1))
(test-eqv
 1267650600228229401496703205376+1267650600228229401496703205376i
 (* 1+i 1267650600228229401496703205376))
(test-eqv 1/2+1/2i (* 1+i 1/2))
(test-eqv 1.+1.i (* 1+i 1.))
(test-eqv +2i (* 1+i 1+i))
(if (eqv? 0 (* 0 0.))
    ;; These tests exercise (macro-special-case-exact-zero?)
    (begin (test-eqv 8.-0.i (* 4.-0.i 2.)) (test-eqv 0 (* 4. 0))))

#;
(let* ((exact-arguments ;; expressions
        '((expt   2 10000)
          (expt 5/2 10000)
          (expt 2/5 10000)))
       (inexact-arguments
        ;; numbers, (list-ref inexact-arguments k) = (/ (list-ref (reverse inexact-arguments) k))
        '(+0. -0. -inf.0 +inf.0)))
  (for-each (lambda (inexact inexact-inverse)
              (for-each (lambda (exact)
                          (pp `(check-eqv? (* ,inexact    ,exact)     ,inexact))
                          (pp `(check-eqv? (* ,inexact (- ,exact)) ,(- inexact)))
                          (pp `(check-eqv? (*    ,exact  ,inexact)     ,inexact))
                          (pp `(check-eqv? (* (- ,exact) ,inexact) ,(- inexact)))
                          (pp `(check-eqv? (/ ,inexact    ,exact)     ,inexact))
                          (pp `(check-eqv? (/ ,inexact (- ,exact)) ,(- inexact)))
                          (pp `(check-eqv? (/    ,exact  ,inexact)    ,inexact-inverse))
                          (pp `(check-eqv? (/ (- ,exact) ,inexact) ,(- inexact-inverse))))
                        exact-arguments))
            inexact-arguments
            (reverse inexact-arguments)))

(test-eqv 0. (* 0. (expt 2 10000)))
(test-eqv -0. (* 0. (- (expt 2 10000))))
(test-eqv 0. (* (expt 2 10000) 0.))
(test-eqv -0. (* (- (expt 2 10000)) 0.))
(test-eqv 0. (/ 0. (expt 2 10000)))
(test-eqv -0. (/ 0. (- (expt 2 10000))))
(test-eqv +inf.0 (/ (expt 2 10000) 0.))
(test-eqv -inf.0 (/ (- (expt 2 10000)) 0.))
(test-eqv 0. (* 0. (expt 5/2 10000)))
(test-eqv -0. (* 0. (- (expt 5/2 10000))))
(test-eqv 0. (* (expt 5/2 10000) 0.))
(test-eqv -0. (* (- (expt 5/2 10000)) 0.))
(test-eqv 0. (/ 0. (expt 5/2 10000)))
(test-eqv -0. (/ 0. (- (expt 5/2 10000))))
(test-eqv +inf.0 (/ (expt 5/2 10000) 0.))
(test-eqv -inf.0 (/ (- (expt 5/2 10000)) 0.))
(test-eqv 0. (* 0. (expt 2/5 10000)))
(test-eqv -0. (* 0. (- (expt 2/5 10000))))
(test-eqv 0. (* (expt 2/5 10000) 0.))
(test-eqv -0. (* (- (expt 2/5 10000)) 0.))
(test-eqv 0. (/ 0. (expt 2/5 10000)))
(test-eqv -0. (/ 0. (- (expt 2/5 10000))))
(test-eqv +inf.0 (/ (expt 2/5 10000) 0.))
(test-eqv -inf.0 (/ (- (expt 2/5 10000)) 0.))
(test-eqv -0. (* -0. (expt 2 10000)))
(test-eqv 0. (* -0. (- (expt 2 10000))))
(test-eqv -0. (* (expt 2 10000) -0.))
(test-eqv 0. (* (- (expt 2 10000)) -0.))
(test-eqv -0. (/ -0. (expt 2 10000)))
(test-eqv 0. (/ -0. (- (expt 2 10000))))
(test-eqv -inf.0 (/ (expt 2 10000) -0.))
(test-eqv +inf.0 (/ (- (expt 2 10000)) -0.))
(test-eqv -0. (* -0. (expt 5/2 10000)))
(test-eqv 0. (* -0. (- (expt 5/2 10000))))
(test-eqv -0. (* (expt 5/2 10000) -0.))
(test-eqv 0. (* (- (expt 5/2 10000)) -0.))
(test-eqv -0. (/ -0. (expt 5/2 10000)))
(test-eqv 0. (/ -0. (- (expt 5/2 10000))))
(test-eqv -inf.0 (/ (expt 5/2 10000) -0.))
(test-eqv +inf.0 (/ (- (expt 5/2 10000)) -0.))
(test-eqv -0. (* -0. (expt 2/5 10000)))
(test-eqv 0. (* -0. (- (expt 2/5 10000))))
(test-eqv -0. (* (expt 2/5 10000) -0.))
(test-eqv 0. (* (- (expt 2/5 10000)) -0.))
(test-eqv -0. (/ -0. (expt 2/5 10000)))
(test-eqv 0. (/ -0. (- (expt 2/5 10000))))
(test-eqv -inf.0 (/ (expt 2/5 10000) -0.))
(test-eqv +inf.0 (/ (- (expt 2/5 10000)) -0.))
(test-eqv -inf.0 (* -inf.0 (expt 2 10000)))
(test-eqv +inf.0 (* -inf.0 (- (expt 2 10000))))
(test-eqv -inf.0 (* (expt 2 10000) -inf.0))
(test-eqv +inf.0 (* (- (expt 2 10000)) -inf.0))
(test-eqv -inf.0 (/ -inf.0 (expt 2 10000)))
(test-eqv +inf.0 (/ -inf.0 (- (expt 2 10000))))
(test-eqv -0. (/ (expt 2 10000) -inf.0))
(test-eqv 0. (/ (- (expt 2 10000)) -inf.0))
(test-eqv -inf.0 (* -inf.0 (expt 5/2 10000)))
(test-eqv +inf.0 (* -inf.0 (- (expt 5/2 10000))))
(test-eqv -inf.0 (* (expt 5/2 10000) -inf.0))
(test-eqv +inf.0 (* (- (expt 5/2 10000)) -inf.0))
(test-eqv -inf.0 (/ -inf.0 (expt 5/2 10000)))
(test-eqv +inf.0 (/ -inf.0 (- (expt 5/2 10000))))
(test-eqv -0. (/ (expt 5/2 10000) -inf.0))
(test-eqv 0. (/ (- (expt 5/2 10000)) -inf.0))
(test-eqv -inf.0 (* -inf.0 (expt 2/5 10000)))
(test-eqv +inf.0 (* -inf.0 (- (expt 2/5 10000))))
(test-eqv -inf.0 (* (expt 2/5 10000) -inf.0))
(test-eqv +inf.0 (* (- (expt 2/5 10000)) -inf.0))
(test-eqv -inf.0 (/ -inf.0 (expt 2/5 10000)))
(test-eqv +inf.0 (/ -inf.0 (- (expt 2/5 10000))))
(test-eqv -0. (/ (expt 2/5 10000) -inf.0))
(test-eqv 0. (/ (- (expt 2/5 10000)) -inf.0))
(test-eqv +inf.0 (* +inf.0 (expt 2 10000)))
(test-eqv -inf.0 (* +inf.0 (- (expt 2 10000))))
(test-eqv +inf.0 (* (expt 2 10000) +inf.0))
(test-eqv -inf.0 (* (- (expt 2 10000)) +inf.0))
(test-eqv +inf.0 (/ +inf.0 (expt 2 10000)))
(test-eqv -inf.0 (/ +inf.0 (- (expt 2 10000))))
(test-eqv 0. (/ (expt 2 10000) +inf.0))
(test-eqv -0. (/ (- (expt 2 10000)) +inf.0))
(test-eqv +inf.0 (* +inf.0 (expt 5/2 10000)))
(test-eqv -inf.0 (* +inf.0 (- (expt 5/2 10000))))
(test-eqv +inf.0 (* (expt 5/2 10000) +inf.0))
(test-eqv -inf.0 (* (- (expt 5/2 10000)) +inf.0))
(test-eqv +inf.0 (/ +inf.0 (expt 5/2 10000)))
(test-eqv -inf.0 (/ +inf.0 (- (expt 5/2 10000))))
(test-eqv 0. (/ (expt 5/2 10000) +inf.0))
(test-eqv -0. (/ (- (expt 5/2 10000)) +inf.0))
(test-eqv +inf.0 (* +inf.0 (expt 2/5 10000)))
(test-eqv -inf.0 (* +inf.0 (- (expt 2/5 10000))))
(test-eqv +inf.0 (* (expt 2/5 10000) +inf.0))
(test-eqv -inf.0 (* (- (expt 2/5 10000)) +inf.0))
(test-eqv +inf.0 (/ +inf.0 (expt 2/5 10000)))
(test-eqv -inf.0 (/ +inf.0 (- (expt 2/5 10000))))
(test-eqv 0. (/ (expt 2/5 10000) +inf.0))
(test-eqv -0. (/ (- (expt 2/5 10000)) +inf.0))

#;
(let* ((exact-arguments ;; expressions
        '((expt   2 10000)
          (expt 5/2 10000)))
       (inexact-arguments
        ;; numbers
        '(+inf.0 -inf.0)))
  (for-each (lambda (inexact)
              (for-each (lambda (exact)
                          (pp `(check-eqv? (+ ,inexact    ,exact)      ,inexact))
                          (pp `(check-eqv? (+ ,inexact (- ,exact))     ,inexact))
                          (pp `(check-eqv? (+    ,exact  ,inexact)     ,inexact))
                          (pp `(check-eqv? (+ (- ,exact) ,inexact)     ,inexact))
                          (pp `(check-eqv? (- ,inexact    ,exact)      ,inexact))
                          (pp `(check-eqv? (- ,inexact (- ,exact))     ,inexact))
                          (pp `(check-eqv? (-    ,exact  ,inexact)  ,(- inexact)))
                          (pp `(check-eqv? (- (- ,exact) ,inexact)  ,(- inexact))))
                        exact-arguments))
            inexact-arguments))

(test-eqv +inf.0 (+ +inf.0 (expt 2 10000)))
(test-eqv +inf.0 (+ +inf.0 (- (expt 2 10000))))
(test-eqv +inf.0 (+ (expt 2 10000) +inf.0))
(test-eqv +inf.0 (+ (- (expt 2 10000)) +inf.0))
(test-eqv +inf.0 (- +inf.0 (expt 2 10000)))
(test-eqv +inf.0 (- +inf.0 (- (expt 2 10000))))
(test-eqv -inf.0 (- (expt 2 10000) +inf.0))
(test-eqv -inf.0 (- (- (expt 2 10000)) +inf.0))
(test-eqv +inf.0 (+ +inf.0 (expt 5/2 10000)))
(test-eqv +inf.0 (+ +inf.0 (- (expt 5/2 10000))))
(test-eqv +inf.0 (+ (expt 5/2 10000) +inf.0))
(test-eqv +inf.0 (+ (- (expt 5/2 10000)) +inf.0))
(test-eqv +inf.0 (- +inf.0 (expt 5/2 10000)))
(test-eqv +inf.0 (- +inf.0 (- (expt 5/2 10000))))
(test-eqv -inf.0 (- (expt 5/2 10000) +inf.0))
(test-eqv -inf.0 (- (- (expt 5/2 10000)) +inf.0))
(test-eqv -inf.0 (+ -inf.0 (expt 2 10000)))
(test-eqv -inf.0 (+ -inf.0 (- (expt 2 10000))))
(test-eqv -inf.0 (+ (expt 2 10000) -inf.0))
(test-eqv -inf.0 (+ (- (expt 2 10000)) -inf.0))
(test-eqv -inf.0 (- -inf.0 (expt 2 10000)))
(test-eqv -inf.0 (- -inf.0 (- (expt 2 10000))))
(test-eqv +inf.0 (- (expt 2 10000) -inf.0))
(test-eqv +inf.0 (- (- (expt 2 10000)) -inf.0))
(test-eqv -inf.0 (+ -inf.0 (expt 5/2 10000)))
(test-eqv -inf.0 (+ -inf.0 (- (expt 5/2 10000))))
(test-eqv -inf.0 (+ (expt 5/2 10000) -inf.0))
(test-eqv -inf.0 (+ (- (expt 5/2 10000)) -inf.0))
(test-eqv -inf.0 (- -inf.0 (expt 5/2 10000)))
(test-eqv -inf.0 (- -inf.0 (- (expt 5/2 10000))))
(test-eqv +inf.0 (- (expt 5/2 10000) -inf.0))
(test-eqv +inf.0 (- (- (expt 5/2 10000)) -inf.0))

#;
(let* ((exact-arguments ;; expressions
        '((expt   2 1024)
          (expt #e2.0001 1024)))
       (inexact-arguments
        ;; numbers
        (list (expt 2. 1023))))
  (for-each (lambda (inexact)
              (for-each (lambda (exact)
                          (pp `(check-true (finite? (+ ,exact ,(- inexact)))))
                          (pp `(check-true (finite? (+ ,(- inexact) ,exact))))

                          (pp `(check-true (finite? (- ,inexact ,exact))))
                          (pp `(check-true (finite? (- ,exact ,inexact)))))
                        exact-arguments))
            inexact-arguments))

(test-assert (eq? #t (finite? (+ (expt 2 1024) -8.98846567431158e307))))
(test-assert (eq? #t (finite? (+ -8.98846567431158e307 (expt 2 1024)))))
(test-assert (eq? #t (finite? (- 8.98846567431158e307 (expt 2 1024)))))
(test-assert (eq? #t (finite? (- (expt 2 1024) 8.98846567431158e307))))
(test-assert
 (eq? #t (finite? (+ (expt 20001/10000 1024) -8.98846567431158e307))))
(test-assert
 (eq? #t (finite? (+ -8.98846567431158e307 (expt 20001/10000 1024)))))
(test-assert
 (eq? #t (finite? (- 8.98846567431158e307 (expt 20001/10000 1024)))))
(test-assert
 (eq? #t (finite? (- (expt 20001/10000 1024) 8.98846567431158e307))))

#;
(let ()
  (pp `(check-eqv? (* (expt 2 1500) ,(inexact (expt 2 -750))) ,(inexact (expt 2 750))))
  (pp `(check-eqv? (* ,(inexact (expt 2 -750)) (expt 2 1500)) ,(inexact (expt 2 750))))

  (pp `(check-eqv? (* (expt #e2.1 1500) ,(inexact (expt 2 -750))) ,(inexact (* (expt #e2.1 1500) (expt 2 -750)))))
  (pp `(check-eqv? (* ,(inexact (expt 2 -750)) (expt #e2.1 1500)) ,(inexact (* (expt #e2.1 1500) (expt 2 -750)))))

  (pp `(check-eqv? (* (expt 2 -1500) ,(inexact (expt 2 750))) ,(inexact (expt 2 -750))))
  (pp `(check-eqv? (* ,(inexact (expt 2 750)) (expt 2 -1500)) ,(inexact (expt 2 -750))))

  (pp `(check-eqv? (* (expt #e2.1 -1500) ,(inexact (expt 2 750))) ,(inexact (* (expt #e2.1 -1500) (expt 2 750)))))
  (pp `(check-eqv? (* ,(inexact (expt 2 750)) (expt #e2.1 -1500)) ,(inexact (* (expt #e2.1 -1500) (expt 2 750)))))

  (pp `(check-eqv? (/ (expt 2 1500) ,(inexact (expt 2 750))) ,(inexact (expt 2 +750))))
  (pp `(check-eqv? (/ ,(inexact (expt 2 750)) (expt 2 1500)) ,(inexact (expt 2 -750))))

  (pp `(check-eqv? (/ (expt #e2.1 1500) ,(inexact (expt 2 750))) ,(inexact (/ (expt #e2.1 1500) (expt 2 750)))))
  (pp `(check-eqv? (/ ,(inexact (expt 2 750)) (expt #e2.1 1500)) ,(inexact (/ (expt 2 750) (expt #e2.1 1500)))))

  (pp `(check-eqv? (/ (expt 2 -1500) ,(inexact (expt 2 -750))) ,(inexact (expt 2 -750))))
  (pp `(check-eqv? (/ ,(inexact (expt 2 -750)) (expt 2 -1500)) ,(inexact (expt 2 +750))))

  (pp `(check-eqv? (/ (expt #e2.1 1500) ,(inexact (expt 2 750))) ,(inexact (/ (expt #e2.1 1500) (expt 2 750)))))
  (pp `(check-eqv? (/ ,(inexact (expt 2 750)) (expt #e2.1 1500)) ,(inexact (/ (expt 2 750) (expt #e2.1 1500)))))

)

(test-eqv 5.922386521532856e225 (* (expt 2 1500) 1.688508503057271e-226))
(test-eqv 5.922386521532856e225 (* 1.688508503057271e-226 (expt 2 1500)))
(test-eqv 3.6011843398019324e257 (* (expt 21/10 1500) 1.688508503057271e-226))
(test-eqv 3.6011843398019324e257 (* 1.688508503057271e-226 (expt 21/10 1500)))
(test-eqv 1.688508503057271e-226 (* (expt 2 -1500) 5.922386521532856e225))
(test-eqv 1.688508503057271e-226 (* 5.922386521532856e225 (expt 2 -1500)))
(test-eqv 2.776864235878024e-258 (* (expt 21/10 -1500) 5.922386521532856e225))
(test-eqv 2.776864235878024e-258 (* 5.922386521532856e225 (expt 21/10 -1500)))
(test-eqv 5.922386521532856e225 (/ (expt 2 1500) 5.922386521532856e225))
(test-eqv 1.688508503057271e-226 (/ 5.922386521532856e225 (expt 2 1500)))
(test-eqv 3.6011843398019324e257 (/ (expt 21/10 1500) 5.922386521532856e225))
(test-eqv 2.776864235878024e-258 (/ 5.922386521532856e225 (expt 21/10 1500)))
(test-eqv 1.688508503057271e-226 (/ (expt 2 -1500) 1.688508503057271e-226))
(test-eqv 5.922386521532856e225 (/ 1.688508503057271e-226 (expt 2 -1500)))
(test-eqv 3.6011843398019324e257 (/ (expt 21/10 1500) 5.922386521532856e225))
(test-eqv 2.776864235878024e-258 (/ 5.922386521532856e225 (expt 21/10 1500)))


(let ((arg 1)) (test-equal (* 1 arg) arg))
(let ((arg 1)) (test-equal (* arg 1) arg))
(let ((arg 1)) (test-equal (+ 0 arg) arg))
(let ((arg 1)) (test-equal (+ arg 0) arg))
(let ((arg 1)) (test-equal (/ arg 1) arg))
(let ((arg 1)) (test-equal (- arg 0) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (* 1 arg) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (* arg 1) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (+ 0 arg) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (+ arg 0) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (/ arg 1) arg))
(let ((arg 1267650600228229401496703205376)) (test-equal (- arg 0) arg))
(let ((arg 1/2)) (test-equal (* 1 arg) arg))
(let ((arg 1/2)) (test-equal (* arg 1) arg))
(let ((arg 1/2)) (test-equal (+ 0 arg) arg))
(let ((arg 1/2)) (test-equal (+ arg 0) arg))
(let ((arg 1/2)) (test-equal (/ arg 1) arg))
(let ((arg 1/2)) (test-equal (- arg 0) arg))
(let ((arg 1.)) (test-equal (* 1 arg) arg))
(let ((arg 1.)) (test-equal (* arg 1) arg))
(let ((arg 1.)) (test-equal (+ 0 arg) arg))
(let ((arg 1.)) (test-equal (+ arg 0) arg))
(let ((arg 1.)) (test-equal (/ arg 1) arg))
(let ((arg 1.)) (test-equal (- arg 0) arg))
(let ((arg 1+i)) (test-equal (* 1 arg) arg))
(let ((arg 1+i)) (test-equal (* arg 1) arg))
(let ((arg 1+i)) (test-equal (+ 0 arg) arg))
(let ((arg 1+i)) (test-equal (+ arg 0) arg))
(let ((arg 1+i)) (test-equal (/ arg 1) arg))
(let ((arg 1+i)) (test-equal (- arg 0) arg))

(test-error-tail divide-by-zero-exception? (/ 1 0))
(test-error-tail
 divide-by-zero-exception?
 (/ 1267650600228229401496703205376 0))
(test-error-tail divide-by-zero-exception? (/ 1/2 0))
(test-error-tail divide-by-zero-exception? (/ 1. 0))
(test-error-tail divide-by-zero-exception? (/ 1+i 0))

(test-eqv `,(+ (##greatest-fixnum) 1) (+ (##greatest-fixnum) 1))
(test-eqv `,(+ 1 (##greatest-fixnum)) (+ 1 (##greatest-fixnum)))
(test-eqv `,(* (##greatest-fixnum) 2) (* (##greatest-fixnum) 2))
(test-eqv `,(* 2 (##greatest-fixnum)) (* 2 (##greatest-fixnum)))
(test-eqv `,(- (##least-fixnum) 1) (- (##least-fixnum) 1))
(test-eqv `,(+ (##greatest-fixnum) 1) (- (##least-fixnum)))

;;; I should include the programs to generate the arguments to the
;;; next tests
#;
(let ()

  ;; These are designed so that (a) each one is exactly representable
  ;; and (b) their sum, difference and product are exactly representable
  ;; But we need to check that.

  ;; Division (/) needs something different, which I'll work out later

  ;; This is incorrect, the result is not a ratnum.

     (define operands `(1             ; fixnum
			,(expt 2 70)  ; bignum
			3/4           ; ratnum
			,(expt 2. 35) ; flonum
			1+i           ; cpxnum
			))

  (for-each (lambda (op op-name)
	      (for-each (lambda (x)
			  (for-each (lambda (y)
				      ;; first check result is exactly representable
				      (for-each display (list "(check-=    ("
							      op-name
							      " "
							      x
							      " "
							      y
							      ") "
							      (op (inexact->exact x) (inexact->exact y))
							      ")\n"
							      ))
				      ;; then check result is eqv? (includes inexactness check)
				      (for-each display (list "(check-eqv? ("
							      op-name
							      " "
							      x
							      " "
							      y
							      ") "
							      (op x y)
							      ")\n"
							      ))
				      )
				    operands))
			operands)
	      )
	    (list + - *) '(+ - *))

  )

(test-approximate 2 (+ 1 1) 1e-12)
(test-eqv 2 (+ 1 1))
(test-approximate 1180591620717411303425 (+ 1 1180591620717411303424) 1e-12)
(test-eqv 1180591620717411303425 (+ 1 1180591620717411303424))
(test-approximate 7/4 (+ 1 3/4) 1e-12)
(test-eqv 7/4 (+ 1 3/4))
(test-approximate 34359738369 (+ 1 3.4359738368e10) 1e-12)
(test-eqv 3.4359738369e10 (+ 1 3.4359738368e10))
(test-approximate 2+i (+ 1 1+i) 1e-12)
(test-eqv 2+i (+ 1 1+i))
(test-approximate 1180591620717411303425 (+ 1180591620717411303424 1) 1e-12)
(test-eqv 1180591620717411303425 (+ 1180591620717411303424 1))
(test-approximate
 2361183241434822606848
 (+ 1180591620717411303424 1180591620717411303424)
 1e-12)
(test-eqv
 2361183241434822606848
 (+ 1180591620717411303424 1180591620717411303424))
(test-approximate
 4722366482869645213699/4
 (+ 1180591620717411303424 3/4)
 1e-12)
(test-eqv 4722366482869645213699/4 (+ 1180591620717411303424 3/4))
(test-approximate
 1180591620751771041792
 (+ 1180591620717411303424 3.4359738368e10)
 1e-12)
(test-eqv 1.180591620751771e21 (+ 1180591620717411303424 3.4359738368e10))
(test-approximate
 1180591620717411303425+i
 (+ 1180591620717411303424 1+i)
 1e-12)
(test-eqv 1180591620717411303425+i (+ 1180591620717411303424 1+i))
(test-approximate 7/4 (+ 3/4 1) 1e-12)
(test-eqv 7/4 (+ 3/4 1))
(test-approximate
 4722366482869645213699/4
 (+ 3/4 1180591620717411303424)
 1e-12)
(test-eqv 4722366482869645213699/4 (+ 3/4 1180591620717411303424))
(test-approximate 3/2 (+ 3/4 3/4) 1e-12)
(test-eqv 3/2 (+ 3/4 3/4))
(test-approximate 137438953475/4 (+ 3/4 3.4359738368e10) 1e-12)
(test-eqv 3.435973836875e10 (+ 3/4 3.4359738368e10))
(test-approximate 7/4+i (+ 3/4 1+i) 1e-12)
(test-eqv 7/4+i (+ 3/4 1+i))
(test-approximate 34359738369 (+ 3.4359738368e10 1) 1e-12)
(test-eqv 3.4359738369e10 (+ 3.4359738368e10 1))
(test-approximate
 1180591620751771041792
 (+ 3.4359738368e10 1180591620717411303424)
 1e-12)
(test-eqv 1.180591620751771e21 (+ 3.4359738368e10 1180591620717411303424))
(test-approximate 137438953475/4 (+ 3.4359738368e10 3/4) 1e-12)
(test-eqv 3.435973836875e10 (+ 3.4359738368e10 3/4))
(test-approximate 68719476736 (+ 3.4359738368e10 3.4359738368e10) 1e-12)
(test-eqv 6.8719476736e10 (+ 3.4359738368e10 3.4359738368e10))
(test-approximate 34359738369+i (+ 3.4359738368e10 1+i) 1e-12)
(test-eqv 3.4359738369e10+i (+ 3.4359738368e10 1+i))
(test-approximate 2+i (+ 1+i 1) 1e-12)
(test-eqv 2+i (+ 1+i 1))
(test-approximate
 1180591620717411303425+i
 (+ 1+i 1180591620717411303424)
 1e-12)
(test-eqv 1180591620717411303425+i (+ 1+i 1180591620717411303424))
(test-approximate 7/4+i (+ 1+i 3/4) 1e-12)
(test-eqv 7/4+i (+ 1+i 3/4))
(test-approximate 34359738369+i (+ 1+i 3.4359738368e10) 1e-12)
(test-eqv 3.4359738369e10+i (+ 1+i 3.4359738368e10))
(test-approximate 2+2i (+ 1+i 1+i) 1e-12)
(test-eqv 2+2i (+ 1+i 1+i))
(test-approximate 0 (- 1 1) 1e-12)
(test-eqv 0 (- 1 1))
(test-approximate -1180591620717411303423 (- 1 1180591620717411303424) 1e-12)
(test-eqv -1180591620717411303423 (- 1 1180591620717411303424))
(test-approximate 1/4 (- 1 3/4) 1e-12)
(test-eqv 1/4 (- 1 3/4))
(test-approximate -34359738367 (- 1 3.4359738368e10) 1e-12)
(test-eqv -3.4359738367e10 (- 1 3.4359738368e10))
(test-approximate -i (- 1 1+i) 1e-12)
(test-eqv -i (- 1 1+i))
(test-approximate 1180591620717411303423 (- 1180591620717411303424 1) 1e-12)
(test-eqv 1180591620717411303423 (- 1180591620717411303424 1))
(test-approximate 0 (- 1180591620717411303424 1180591620717411303424) 1e-12)
(test-eqv 0 (- 1180591620717411303424 1180591620717411303424))
(test-approximate
 4722366482869645213693/4
 (- 1180591620717411303424 3/4)
 1e-12)
(test-eqv 4722366482869645213693/4 (- 1180591620717411303424 3/4))
(test-approximate
 1180591620683051565056
 (- 1180591620717411303424 3.4359738368e10)
 1e-12)
(test-eqv 1.1805916206830516e21 (- 1180591620717411303424 3.4359738368e10))
(test-approximate
 1180591620717411303423-i
 (- 1180591620717411303424 1+i)
 1e-12)
(test-eqv 1180591620717411303423-i (- 1180591620717411303424 1+i))
(test-approximate -1/4 (- 3/4 1) 1e-12)
(test-eqv -1/4 (- 3/4 1))
(test-approximate
 -4722366482869645213693/4
 (- 3/4 1180591620717411303424)
 1e-12)
(test-eqv -4722366482869645213693/4 (- 3/4 1180591620717411303424))
(test-approximate 0 (- 3/4 3/4) 1e-12)
(test-eqv 0 (- 3/4 3/4))
(test-approximate -137438953469/4 (- 3/4 3.4359738368e10) 1e-12)
(test-eqv -3.435973836725e10 (- 3/4 3.4359738368e10))
(test-approximate -1/4-i (- 3/4 1+i) 1e-12)
(test-eqv -1/4-i (- 3/4 1+i))
(test-approximate 34359738367 (- 3.4359738368e10 1) 1e-12)
(test-eqv 3.4359738367e10 (- 3.4359738368e10 1))
(test-approximate
 -1180591620683051565056
 (- 3.4359738368e10 1180591620717411303424)
 1e-12)
(test-eqv -1.1805916206830516e21 (- 3.4359738368e10 1180591620717411303424))
(test-approximate 137438953469/4 (- 3.4359738368e10 3/4) 1e-12)
(test-eqv 3.435973836725e10 (- 3.4359738368e10 3/4))
(test-approximate 0 (- 3.4359738368e10 3.4359738368e10) 1e-12)
(test-eqv 0. (- 3.4359738368e10 3.4359738368e10))
(test-approximate 34359738367-i (- 3.4359738368e10 1+i) 1e-12)
(test-eqv 3.4359738367e10-i (- 3.4359738368e10 1+i))
(test-approximate +i (- 1+i 1) 1e-12)
(test-eqv +i (- 1+i 1))
(test-approximate
 -1180591620717411303423+i
 (- 1+i 1180591620717411303424)
 1e-12)
(test-eqv -1180591620717411303423+i (- 1+i 1180591620717411303424))
(test-approximate 1/4+i (- 1+i 3/4) 1e-12)
(test-eqv 1/4+i (- 1+i 3/4))
(test-approximate -34359738367+i (- 1+i 3.4359738368e10) 1e-12)
(test-eqv -3.4359738367e10+i (- 1+i 3.4359738368e10))
(test-approximate 0 (- 1+i 1+i) 1e-12)
(test-eqv 0 (- 1+i 1+i))
(test-approximate 1 (* 1 1) 1e-12)
(test-eqv 1 (* 1 1))
(test-approximate 1180591620717411303424 (* 1 1180591620717411303424) 1e-12)
(test-eqv 1180591620717411303424 (* 1 1180591620717411303424))
(test-approximate 3/4 (* 1 3/4) 1e-12)
(test-eqv 3/4 (* 1 3/4))
(test-approximate 34359738368 (* 1 3.4359738368e10) 1e-12)
(test-eqv 3.4359738368e10 (* 1 3.4359738368e10))
(test-approximate 1+i (* 1 1+i) 1e-12)
(test-eqv 1+i (* 1 1+i))
(test-approximate 1180591620717411303424 (* 1180591620717411303424 1) 1e-12)
(test-eqv 1180591620717411303424 (* 1180591620717411303424 1))
(test-approximate
 1393796574908163946345982392040522594123776
 (* 1180591620717411303424 1180591620717411303424)
 1e-12)
(test-eqv
 1393796574908163946345982392040522594123776
 (* 1180591620717411303424 1180591620717411303424))
(test-approximate 885443715538058477568 (* 1180591620717411303424 3/4) 1e-12)
(test-eqv 885443715538058477568 (* 1180591620717411303424 3/4))
(test-approximate
 40564819207303340847894502572032
 (* 1180591620717411303424 3.4359738368e10)
 1e-12)
(test-eqv 4.056481920730334e31 (* 1180591620717411303424 3.4359738368e10))
(test-approximate
 1180591620717411303424+1180591620717411303424i
 (* 1180591620717411303424 1+i)
 1e-12)
(test-eqv
 1180591620717411303424+1180591620717411303424i
 (* 1180591620717411303424 1+i))
(test-approximate 3/4 (* 3/4 1) 1e-12)
(test-eqv 3/4 (* 3/4 1))
(test-approximate 885443715538058477568 (* 3/4 1180591620717411303424) 1e-12)
(test-eqv 885443715538058477568 (* 3/4 1180591620717411303424))
(test-approximate 9/16 (* 3/4 3/4) 1e-12)
(test-eqv 9/16 (* 3/4 3/4))
(test-approximate 25769803776 (* 3/4 3.4359738368e10) 1e-12)
(test-eqv 2.5769803776e10 (* 3/4 3.4359738368e10))
(test-approximate 3/4+3/4i (* 3/4 1+i) 1e-12)
(test-eqv 3/4+3/4i (* 3/4 1+i))
(test-approximate 34359738368 (* 3.4359738368e10 1) 1e-12)
(test-eqv 3.4359738368e10 (* 3.4359738368e10 1))
(test-approximate
 40564819207303340847894502572032
 (* 3.4359738368e10 1180591620717411303424)
 1e-12)
(test-eqv 4.056481920730334e31 (* 3.4359738368e10 1180591620717411303424))
(test-approximate 25769803776 (* 3.4359738368e10 3/4) 1e-12)
(test-eqv 2.5769803776e10 (* 3.4359738368e10 3/4))
(test-approximate
 1180591620717411303424
 (* 3.4359738368e10 3.4359738368e10)
 1e-12)
(test-eqv 1.1805916207174113e21 (* 3.4359738368e10 3.4359738368e10))
(test-approximate 34359738368+34359738368i (* 3.4359738368e10 1+i) 1e-12)
(test-eqv 3.4359738368e10+3.4359738368e10i (* 3.4359738368e10 1+i))
(test-approximate 1+i (* 1+i 1) 1e-12)
(test-eqv 1+i (* 1+i 1))
(test-approximate
 1180591620717411303424+1180591620717411303424i
 (* 1+i 1180591620717411303424)
 1e-12)
(test-eqv
 1180591620717411303424+1180591620717411303424i
 (* 1+i 1180591620717411303424))
(test-approximate 3/4+3/4i (* 1+i 3/4) 1e-12)
(test-eqv 3/4+3/4i (* 1+i 3/4))
(test-approximate 34359738368+34359738368i (* 1+i 3.4359738368e10) 1e-12)
(test-eqv 3.4359738368e10+3.4359738368e10i (* 1+i 3.4359738368e10))
(test-approximate +2i (* 1+i 1+i) 1e-12)
(test-eqv +2i (* 1+i 1+i))


#;(let ()

  (define (make-symbol . args)
    (string->symbol (apply string-append (map (lambda (x) (if (symbol? x) (symbol->string x) x)) args))))

  (let ((ns (list (random-integer (expt 2 400))
		  (- (random-integer (expt 2 400)))
		  (random-integer (##greatest-fixnum))
		  (- (random-integer (##greatest-fixnum)))))
	(sizes (list (random-integer 200)
		     (random-integer 20)))
	(positions (list (random-integer 200)
			 (random-integer 20))))
    (for-each (lambda (op-name)
		(for-each (lambda (n)
			    (for-each (lambda (size)
					(for-each (lambda (position)
						    (for-each display (list "(check-eqv? ("
									    op-name
									    " "
									    size
									    " "
									    position
									    " "
									    n
									    ") ("
									    (make-symbol 'test- op-name)
									    " "
									    size
									    " "
									    position
									    " "
									    n
									    "))\n")))
						  positions))
				      sizes))
			  ns))
	      '(extract-bit-field test-bit-field? clear-bit-field))
    ))

(test-eqv
 (test-extract-bit-field
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (extract-bit-field
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-extract-bit-field
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (extract-bit-field
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-extract-bit-field
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (extract-bit-field
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-extract-bit-field
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (extract-bit-field
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-extract-bit-field
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (extract-bit-field
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-extract-bit-field
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (extract-bit-field
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-extract-bit-field
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (extract-bit-field
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-extract-bit-field
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (extract-bit-field
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-extract-bit-field 79 109 103713854486608146)
 (extract-bit-field 79 109 103713854486608146))
(test-eqv
 (test-extract-bit-field 79 13 103713854486608146)
 (extract-bit-field 79 13 103713854486608146))
(test-eqv
 (test-extract-bit-field 4 109 103713854486608146)
 (extract-bit-field 4 109 103713854486608146))
(test-eqv
 (test-extract-bit-field 4 13 103713854486608146)
 (extract-bit-field 4 13 103713854486608146))
(test-eqv
 (test-extract-bit-field 79 109 -608462309321751311)
 (extract-bit-field 79 109 -608462309321751311))
(test-eqv
 (test-extract-bit-field 79 13 -608462309321751311)
 (extract-bit-field 79 13 -608462309321751311))
(test-eqv
 (test-extract-bit-field 4 109 -608462309321751311)
 (extract-bit-field 4 109 -608462309321751311))
(test-eqv
 (test-extract-bit-field 4 13 -608462309321751311)
 (extract-bit-field 4 13 -608462309321751311))
(test-eqv
 (test-test-bit-field?
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (test-bit-field?
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-test-bit-field?
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (test-bit-field?
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-test-bit-field?
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (test-bit-field?
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-test-bit-field?
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (test-bit-field?
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-test-bit-field?
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (test-bit-field?
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-test-bit-field?
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (test-bit-field?
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-test-bit-field?
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (test-bit-field?
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-test-bit-field?
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (test-bit-field?
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-test-bit-field? 79 109 103713854486608146)
 (test-bit-field? 79 109 103713854486608146))
(test-eqv
 (test-test-bit-field? 79 13 103713854486608146)
 (test-bit-field? 79 13 103713854486608146))
(test-eqv
 (test-test-bit-field? 4 109 103713854486608146)
 (test-bit-field? 4 109 103713854486608146))
(test-eqv
 (test-test-bit-field? 4 13 103713854486608146)
 (test-bit-field? 4 13 103713854486608146))
(test-eqv
 (test-test-bit-field? 79 109 -608462309321751311)
 (test-bit-field? 79 109 -608462309321751311))
(test-eqv
 (test-test-bit-field? 79 13 -608462309321751311)
 (test-bit-field? 79 13 -608462309321751311))
(test-eqv
 (test-test-bit-field? 4 109 -608462309321751311)
 (test-bit-field? 4 109 -608462309321751311))
(test-eqv
 (test-test-bit-field? 4 13 -608462309321751311)
 (test-bit-field? 4 13 -608462309321751311))
(test-eqv
 (test-clear-bit-field
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (clear-bit-field
  79
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-clear-bit-field
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (clear-bit-field
  79
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-clear-bit-field
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (clear-bit-field
  4
  109
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-clear-bit-field
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261)
 (clear-bit-field
  4
  13
  819289025694944586759318860605577375432306836892969486208725872284023634378009092711199478706560747106627062245621894261))
(test-eqv
 (test-clear-bit-field
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (clear-bit-field
  79
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-clear-bit-field
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (clear-bit-field
  79
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-clear-bit-field
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (clear-bit-field
  4
  109
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-clear-bit-field
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942)
 (clear-bit-field
  4
  13
  -2560481503630520084802251286722070556183711270103420284967696348412255744250015987909211821032873931231996971794614933942))
(test-eqv
 (test-clear-bit-field 79 109 103713854486608146)
 (clear-bit-field 79 109 103713854486608146))
(test-eqv
 (test-clear-bit-field 79 13 103713854486608146)
 (clear-bit-field 79 13 103713854486608146))
(test-eqv
 (test-clear-bit-field 4 109 103713854486608146)
 (clear-bit-field 4 109 103713854486608146))
(test-eqv
 (test-clear-bit-field 4 13 103713854486608146)
 (clear-bit-field 4 13 103713854486608146))
(test-eqv
 (test-clear-bit-field 79 109 -608462309321751311)
 (clear-bit-field 79 109 -608462309321751311))
(test-eqv
 (test-clear-bit-field 79 13 -608462309321751311)
 (clear-bit-field 79 13 -608462309321751311))
(test-eqv
 (test-clear-bit-field 4 109 -608462309321751311)
 (clear-bit-field 4 109 -608462309321751311))
(test-eqv
 (test-clear-bit-field 4 13 -608462309321751311)
 (clear-bit-field 4 13 -608462309321751311))

;;; extract-bit-field

;;; Now some ad-hoc tests with size and position bignums

(test-eqv 15 (extract-bit-field 4 (expt 2 100) -1))
(test-eqv 15 (extract-bit-field (expt 2 100) 0 15))
(test-eqv 0 (extract-bit-field (expt 2 100) (expt 3 100) 15))

;;; Have size be bigger than (integer-length x)

(test-eqv (expt 3 110) (extract-bit-field 200 0 (expt 3 110)))

;;; This is a quality of implementation test:

(let ((x (expt 3 110))) (test-eq x (extract-bit-field 200 0 x)))

;;; Some error tests.

;;; heap-overflow-exception? doesn't seem to exist in the universal back end.
;;; (check-exn heap-overflow-exception? (lambda () (extract-bit-field (expt 2 100) (expt 2 100) -1)))

(test-error-tail type-exception? (extract-bit-field -1 1 1))
(test-error-tail type-exception? (extract-bit-field 1 -1 1))
(test-error-tail type-exception? (extract-bit-field 'a 1 1))
(test-error-tail type-exception? (extract-bit-field 1 'a 1))
(test-error-tail type-exception? (extract-bit-field 1 1 'a))

;;; test-bit-field

;;; Some ad-hoc tests

#| The following was generated with:

(for-each (lambda (n)
            (for-each (lambda (size)
                        (for-each (lambda (position)
                                    (pp `(check-eqv? (test-bit-field?      ,size ,position ,n)
                                                     (test-test-bit-field? ,size ,position ,n))))
                                  (iota 3 0)))
                      (iota 3 1)))
          (iota 9 -4))
|#

(test-eqv (test-test-bit-field? 1 0 -4) (test-bit-field? 1 0 -4))
(test-eqv (test-test-bit-field? 1 1 -4) (test-bit-field? 1 1 -4))
(test-eqv (test-test-bit-field? 1 2 -4) (test-bit-field? 1 2 -4))
(test-eqv (test-test-bit-field? 2 0 -4) (test-bit-field? 2 0 -4))
(test-eqv (test-test-bit-field? 2 1 -4) (test-bit-field? 2 1 -4))
(test-eqv (test-test-bit-field? 2 2 -4) (test-bit-field? 2 2 -4))
(test-eqv (test-test-bit-field? 3 0 -4) (test-bit-field? 3 0 -4))
(test-eqv (test-test-bit-field? 3 1 -4) (test-bit-field? 3 1 -4))
(test-eqv (test-test-bit-field? 3 2 -4) (test-bit-field? 3 2 -4))
(test-eqv (test-test-bit-field? 1 0 -3) (test-bit-field? 1 0 -3))
(test-eqv (test-test-bit-field? 1 1 -3) (test-bit-field? 1 1 -3))
(test-eqv (test-test-bit-field? 1 2 -3) (test-bit-field? 1 2 -3))
(test-eqv (test-test-bit-field? 2 0 -3) (test-bit-field? 2 0 -3))
(test-eqv (test-test-bit-field? 2 1 -3) (test-bit-field? 2 1 -3))
(test-eqv (test-test-bit-field? 2 2 -3) (test-bit-field? 2 2 -3))
(test-eqv (test-test-bit-field? 3 0 -3) (test-bit-field? 3 0 -3))
(test-eqv (test-test-bit-field? 3 1 -3) (test-bit-field? 3 1 -3))
(test-eqv (test-test-bit-field? 3 2 -3) (test-bit-field? 3 2 -3))
(test-eqv (test-test-bit-field? 1 0 -2) (test-bit-field? 1 0 -2))
(test-eqv (test-test-bit-field? 1 1 -2) (test-bit-field? 1 1 -2))
(test-eqv (test-test-bit-field? 1 2 -2) (test-bit-field? 1 2 -2))
(test-eqv (test-test-bit-field? 2 0 -2) (test-bit-field? 2 0 -2))
(test-eqv (test-test-bit-field? 2 1 -2) (test-bit-field? 2 1 -2))
(test-eqv (test-test-bit-field? 2 2 -2) (test-bit-field? 2 2 -2))
(test-eqv (test-test-bit-field? 3 0 -2) (test-bit-field? 3 0 -2))
(test-eqv (test-test-bit-field? 3 1 -2) (test-bit-field? 3 1 -2))
(test-eqv (test-test-bit-field? 3 2 -2) (test-bit-field? 3 2 -2))
(test-eqv (test-test-bit-field? 1 0 -1) (test-bit-field? 1 0 -1))
(test-eqv (test-test-bit-field? 1 1 -1) (test-bit-field? 1 1 -1))
(test-eqv (test-test-bit-field? 1 2 -1) (test-bit-field? 1 2 -1))
(test-eqv (test-test-bit-field? 2 0 -1) (test-bit-field? 2 0 -1))
(test-eqv (test-test-bit-field? 2 1 -1) (test-bit-field? 2 1 -1))
(test-eqv (test-test-bit-field? 2 2 -1) (test-bit-field? 2 2 -1))
(test-eqv (test-test-bit-field? 3 0 -1) (test-bit-field? 3 0 -1))
(test-eqv (test-test-bit-field? 3 1 -1) (test-bit-field? 3 1 -1))
(test-eqv (test-test-bit-field? 3 2 -1) (test-bit-field? 3 2 -1))
(test-eqv (test-test-bit-field? 1 0 0) (test-bit-field? 1 0 0))
(test-eqv (test-test-bit-field? 1 1 0) (test-bit-field? 1 1 0))
(test-eqv (test-test-bit-field? 1 2 0) (test-bit-field? 1 2 0))
(test-eqv (test-test-bit-field? 2 0 0) (test-bit-field? 2 0 0))
(test-eqv (test-test-bit-field? 2 1 0) (test-bit-field? 2 1 0))
(test-eqv (test-test-bit-field? 2 2 0) (test-bit-field? 2 2 0))
(test-eqv (test-test-bit-field? 3 0 0) (test-bit-field? 3 0 0))
(test-eqv (test-test-bit-field? 3 1 0) (test-bit-field? 3 1 0))
(test-eqv (test-test-bit-field? 3 2 0) (test-bit-field? 3 2 0))
(test-eqv (test-test-bit-field? 1 0 1) (test-bit-field? 1 0 1))
(test-eqv (test-test-bit-field? 1 1 1) (test-bit-field? 1 1 1))
(test-eqv (test-test-bit-field? 1 2 1) (test-bit-field? 1 2 1))
(test-eqv (test-test-bit-field? 2 0 1) (test-bit-field? 2 0 1))
(test-eqv (test-test-bit-field? 2 1 1) (test-bit-field? 2 1 1))
(test-eqv (test-test-bit-field? 2 2 1) (test-bit-field? 2 2 1))
(test-eqv (test-test-bit-field? 3 0 1) (test-bit-field? 3 0 1))
(test-eqv (test-test-bit-field? 3 1 1) (test-bit-field? 3 1 1))
(test-eqv (test-test-bit-field? 3 2 1) (test-bit-field? 3 2 1))
(test-eqv (test-test-bit-field? 1 0 2) (test-bit-field? 1 0 2))
(test-eqv (test-test-bit-field? 1 1 2) (test-bit-field? 1 1 2))
(test-eqv (test-test-bit-field? 1 2 2) (test-bit-field? 1 2 2))
(test-eqv (test-test-bit-field? 2 0 2) (test-bit-field? 2 0 2))
(test-eqv (test-test-bit-field? 2 1 2) (test-bit-field? 2 1 2))
(test-eqv (test-test-bit-field? 2 2 2) (test-bit-field? 2 2 2))
(test-eqv (test-test-bit-field? 3 0 2) (test-bit-field? 3 0 2))
(test-eqv (test-test-bit-field? 3 1 2) (test-bit-field? 3 1 2))
(test-eqv (test-test-bit-field? 3 2 2) (test-bit-field? 3 2 2))
(test-eqv (test-test-bit-field? 1 0 3) (test-bit-field? 1 0 3))
(test-eqv (test-test-bit-field? 1 1 3) (test-bit-field? 1 1 3))
(test-eqv (test-test-bit-field? 1 2 3) (test-bit-field? 1 2 3))
(test-eqv (test-test-bit-field? 2 0 3) (test-bit-field? 2 0 3))
(test-eqv (test-test-bit-field? 2 1 3) (test-bit-field? 2 1 3))
(test-eqv (test-test-bit-field? 2 2 3) (test-bit-field? 2 2 3))
(test-eqv (test-test-bit-field? 3 0 3) (test-bit-field? 3 0 3))
(test-eqv (test-test-bit-field? 3 1 3) (test-bit-field? 3 1 3))
(test-eqv (test-test-bit-field? 3 2 3) (test-bit-field? 3 2 3))
(test-eqv (test-test-bit-field? 1 0 4) (test-bit-field? 1 0 4))
(test-eqv (test-test-bit-field? 1 1 4) (test-bit-field? 1 1 4))
(test-eqv (test-test-bit-field? 1 2 4) (test-bit-field? 1 2 4))
(test-eqv (test-test-bit-field? 2 0 4) (test-bit-field? 2 0 4))
(test-eqv (test-test-bit-field? 2 1 4) (test-bit-field? 2 1 4))
(test-eqv (test-test-bit-field? 2 2 4) (test-bit-field? 2 2 4))
(test-eqv (test-test-bit-field? 3 0 4) (test-bit-field? 3 0 4))
(test-eqv (test-test-bit-field? 3 1 4) (test-bit-field? 3 1 4))
(test-eqv (test-test-bit-field? 3 2 4) (test-bit-field? 3 2 4))

;;; the following should not overflow the heap.

(test-eqv #t (test-bit-field? (expt 2 100) (expt 2 100) -1))

;;; Some error tests

(test-error-tail type-exception? (test-bit-field? -1 1 1))
(test-error-tail type-exception? (test-bit-field? 1 -1 1))
(test-error-tail type-exception? (test-bit-field? 'a 1 1))
(test-error-tail type-exception? (test-bit-field? 1 'a 1))
(test-error-tail type-exception? (test-bit-field? 1 1 'a))


#;(let ()

  (define (make-symbol . args)
    (string->symbol (apply string-append (map (lambda (x) (if (symbol? x) (symbol->string x) x)) args))))

  (let ((xs (list (random-integer (expt 2 400))
		  (- (random-integer (expt 2 400)))
		  (random-integer (integer-sqrt (##greatest-fixnum)))
		  (- (random-integer (integer-sqrt (##greatest-fixnum))))))
	(shifts (list (random-integer 200)
		     (random-integer 20)
		     (- (random-integer 200))
		     (- (random-integer 20)))))
    (for-each (lambda (x)
		(for-each (lambda (shift)
					(for-each display (list "(check-eqv? ("
								'arithmetic-shift
								" "
								x
								" "
								shift
								") ("
								(make-symbol 'test- 'arithmetic-shift)
								" "
								x
								" "
								shift
								"))\n")))
			  shifts))
	      xs)
    ))

(test-eqv
 (test-arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  25)
 (arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  25))
(test-eqv
 (test-arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  6)
 (arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  6))
(test-eqv
 (test-arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  -85)
 (arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  -85))
(test-eqv
 (test-arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  -7)
 (arithmetic-shift
  1510654584040625753730018974833480216667530151201555010392492426076866671982958500628614593424711863814629067143762706485
  -7))
(test-eqv
 (test-arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  25)
 (arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  25))
(test-eqv
 (test-arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  6)
 (arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  6))
(test-eqv
 (test-arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  -85)
 (arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  -85))
(test-eqv
 (test-arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  -7)
 (arithmetic-shift
  -559642383537053245096412692765977685103422952228866058440690017354464196389779391618197852441636114137703871379414475911
  -7))
(test-eqv
 (test-arithmetic-shift 1069741397 25)
 (arithmetic-shift 1069741397 25))
(test-eqv (test-arithmetic-shift 1069741397 6) (arithmetic-shift 1069741397 6))
(test-eqv
 (test-arithmetic-shift 1069741397 -85)
 (arithmetic-shift 1069741397 -85))
(test-eqv
 (test-arithmetic-shift 1069741397 -7)
 (arithmetic-shift 1069741397 -7))
(test-eqv
 (test-arithmetic-shift -1094530198 25)
 (arithmetic-shift -1094530198 25))
(test-eqv
 (test-arithmetic-shift -1094530198 6)
 (arithmetic-shift -1094530198 6))
(test-eqv
 (test-arithmetic-shift -1094530198 -85)
 (arithmetic-shift -1094530198 -85))
(test-eqv
 (test-arithmetic-shift -1094530198 -7)
 (arithmetic-shift -1094530198 -7))

#;(let ()

  ;; I'll visually inspect the results

  (let* ((args `(120                        ; fixnum
		 ,(expt 3 64)               ; bignum
		 ,(+ (expt 3 64) 1)         ; close to bignum
		 ,(expt 3 128)              ; bigger bignum (more adigits)
		 ,(+ (expt 3 128) 1)))      ; close to bigger bignum
	 (args (append args (map - args)))) ; and their negatives
    (for-each (lambda (x)
		(for-each (lambda (y)
			    (for-each (lambda (op op-name)
					(for-each display (list "(check-eq? ("
								op-name
								" "
								x
								" "
								y
								") "
								(op x y)
								")\n")))
				      (list < > =)
				      '(< > =)))
			  args))
	      args)))
(test-eq #f (< 120 120))
(test-eq #f (> 120 120))
(test-eq #t (= 120 120))
(test-eq #t (< 120 3433683820292512484657849089281))
(test-eq #f (> 120 3433683820292512484657849089281))
(test-eq #f (= 120 3433683820292512484657849089281))
(test-eq #t (< 120 3433683820292512484657849089282))
(test-eq #f (> 120 3433683820292512484657849089282))
(test-eq #f (= 120 3433683820292512484657849089282))
(test-eq #t
         (< 120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> 120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< 120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> 120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< 120 -120))
(test-eq #t (> 120 -120))
(test-eq #f (= 120 -120))
(test-eq #f (< 120 -3433683820292512484657849089281))
(test-eq #t (> 120 -3433683820292512484657849089281))
(test-eq #f (= 120 -3433683820292512484657849089281))
(test-eq #f (< 120 -3433683820292512484657849089282))
(test-eq #t (> 120 -3433683820292512484657849089282))
(test-eq #f (= 120 -3433683820292512484657849089282))
(test-eq #f
         (< 120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> 120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< 3433683820292512484657849089281 120))
(test-eq #t (> 3433683820292512484657849089281 120))
(test-eq #f (= 3433683820292512484657849089281 120))
(test-eq #f
         (< 3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #f
         (> 3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #t
         (= 3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #t
         (< 3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #f
         (> 3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #f
         (= 3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #t
         (< 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< 3433683820292512484657849089281 -120))
(test-eq #t (> 3433683820292512484657849089281 -120))
(test-eq #f (= 3433683820292512484657849089281 -120))
(test-eq #f
         (< 3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #t
         (> 3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #f
         (= 3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #f
         (< 3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #t
         (> 3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #f
         (= 3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #f
         (< 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< 3433683820292512484657849089282 120))
(test-eq #t (> 3433683820292512484657849089282 120))
(test-eq #f (= 3433683820292512484657849089282 120))
(test-eq #f
         (< 3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #t
         (> 3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #f
         (= 3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #f
         (< 3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #f
         (> 3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #t
         (= 3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #t
         (< 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< 3433683820292512484657849089282 -120))
(test-eq #t (> 3433683820292512484657849089282 -120))
(test-eq #f (= 3433683820292512484657849089282 -120))
(test-eq #f
         (< 3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #t
         (> 3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #f
         (= 3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #f
         (< 3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #t
         (> 3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #f
         (= 3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #f
         (< 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (= 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (= 11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= 11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t (< -120 120))
(test-eq #f (> -120 120))
(test-eq #f (= -120 120))
(test-eq #t (< -120 3433683820292512484657849089281))
(test-eq #f (> -120 3433683820292512484657849089281))
(test-eq #f (= -120 3433683820292512484657849089281))
(test-eq #t (< -120 3433683820292512484657849089282))
(test-eq #f (> -120 3433683820292512484657849089282))
(test-eq #f (= -120 3433683820292512484657849089282))
(test-eq #t
         (< -120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -120
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< -120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -120
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f (< -120 -120))
(test-eq #f (> -120 -120))
(test-eq #t (= -120 -120))
(test-eq #f (< -120 -3433683820292512484657849089281))
(test-eq #t (> -120 -3433683820292512484657849089281))
(test-eq #f (= -120 -3433683820292512484657849089281))
(test-eq #f (< -120 -3433683820292512484657849089282))
(test-eq #t (> -120 -3433683820292512484657849089282))
(test-eq #f (= -120 -3433683820292512484657849089282))
(test-eq #f
         (< -120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> -120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -120
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< -120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> -120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -120
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t (< -3433683820292512484657849089281 120))
(test-eq #f (> -3433683820292512484657849089281 120))
(test-eq #f (= -3433683820292512484657849089281 120))
(test-eq #t
         (< -3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #f
         (> -3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #f
         (= -3433683820292512484657849089281 3433683820292512484657849089281))
(test-eq #t
         (< -3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #f
         (> -3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #f
         (= -3433683820292512484657849089281 3433683820292512484657849089282))
(test-eq #t
         (< -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -3433683820292512484657849089281
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t (< -3433683820292512484657849089281 -120))
(test-eq #f (> -3433683820292512484657849089281 -120))
(test-eq #f (= -3433683820292512484657849089281 -120))
(test-eq #f
         (< -3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #f
         (> -3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #t
         (= -3433683820292512484657849089281 -3433683820292512484657849089281))
(test-eq #f
         (< -3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #t
         (> -3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #f
         (= -3433683820292512484657849089281 -3433683820292512484657849089282))
(test-eq #f
         (< -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -3433683820292512484657849089281
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t (< -3433683820292512484657849089282 120))
(test-eq #f (> -3433683820292512484657849089282 120))
(test-eq #f (= -3433683820292512484657849089282 120))
(test-eq #t
         (< -3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #f
         (> -3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #f
         (= -3433683820292512484657849089282 3433683820292512484657849089281))
(test-eq #t
         (< -3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #f
         (> -3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #f
         (= -3433683820292512484657849089282 3433683820292512484657849089282))
(test-eq #t
         (< -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -3433683820292512484657849089282
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t (< -3433683820292512484657849089282 -120))
(test-eq #f (> -3433683820292512484657849089282 -120))
(test-eq #f (= -3433683820292512484657849089282 -120))
(test-eq #t
         (< -3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #f
         (> -3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #f
         (= -3433683820292512484657849089282 -3433683820292512484657849089281))
(test-eq #f
         (< -3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #f
         (> -3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #t
         (= -3433683820292512484657849089282 -3433683820292512484657849089282))
(test-eq #f
         (< -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (> -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -3433683820292512484657849089282
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            120))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089281))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            3433683820292512484657849089282))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            -120))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089281))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            -3433683820292512484657849089282))
(test-eq #f
         (< -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (= -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (> -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096961
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            120))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089281))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            3433683820292512484657849089282))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096961))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            -120))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089281))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            -3433683820292512484657849089282))
(test-eq #t
         (< -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (= -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096961))
(test-eq #f
         (< -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #f
         (> -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))
(test-eq #t
         (= -11790184577738583171520872861412518665678211592275841109096962
            -11790184577738583171520872861412518665678211592275841109096962))

;;; Some complex tests

(test-eq #t (= 3/4+0.i .75))
(test-eq #f (= 3/4+i 3/4))
(test-eq #t (= +0.i 0))
(test-eq #f (= 3+0.i .8))

