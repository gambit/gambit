(include "#.scm")

;;; Test branch cuts

(test-eqv +i (sqrt -1))
(test-approximate +i (sqrt -1+0.i) 1e-12)
(test-approximate -i (sqrt -1-0.i) 1e-12)

;;; Test some exact values

(test-eqv +i (sqrt -1))
(test-eqv 1+i (sqrt +2i))
(test-eqv 1-i (sqrt -2i))

;;; Test that we avoid double rounding in rational sqrt

(test-eqv .37796447300922725 (sqrt 1/7))
(test-eqv .6546536707079772 (sqrt 3/7))
(test-eqv .7559289460184545 (sqrt 4/7))

;;; std::sqrt(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/sqrt

(test-eqv 0.+0.i (sqrt 0.+0.i))
(test-eqv 0.+0.i (sqrt -0.+0.i))

(test-eqv +inf.0+inf.0i (sqrt +nan.0+inf.0i))
(test-eqv +inf.0+inf.0i (sqrt 200.+inf.0i))

(test-assert (eq? #t (nan? (real-part (sqrt 2.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (sqrt 2.+nan.0i)))))

(test-eqv 0.+inf.0i (sqrt -inf.0+2.i))

(test-eqv +inf.0+0.i (sqrt +inf.0+2.i))

(test-assert (eq? #t (nan? (real-part (sqrt -inf.0+nan.0i)))))
(test-eqv +inf.0 (abs (imag-part (sqrt -inf.0+nan.0i))))

(test-eqv +inf.0 (real-part (sqrt +inf.0+nan.0i)))
(test-assert (eq? #t (nan? (imag-part (sqrt +inf.0+nan.0i)))))

(test-assert (eq? #t (nan? (real-part (sqrt +nan.0+2.i)))))
(test-assert (eq? #t (nan? (imag-part (sqrt +nan.0+2.i)))))

(test-assert (eq? #t (nan? (real-part (sqrt +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (sqrt +nan.0+nan.0i)))))

(let ((args '(0. -0. .5 -.5 1. -1. 2. -2. +inf.0 -inf.0)))
  (for-each
   (lambda (x)
     (for-each
      (lambda (y)
        (let ((z (make-rectangular x y)))
          (test-eqv (conjugate (sqrt z)) (sqrt (conjugate z)))))
      args))
   args))

;;; Test exceptions

(test-error-tail type-exception? (sqrt #\c))

