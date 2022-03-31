(include "#.scm")

;;; Test branch cuts

(check-eqv? (sqrt -1) +i)
(check-= (sqrt -1+0.i) +i)
(check-= (sqrt -1-0.i) -i)

;;; Test some exact values

(check-eqv? (sqrt -1) +i)
(check-eqv? (sqrt +2i) 1+i)
(check-eqv? (sqrt -2i) 1-i)

;;; Test that we avoid double rounding in rational sqrt

(check-eqv? (sqrt 1/7) .37796447300922725)
(check-eqv? (sqrt 3/7) .6546536707079772)
(check-eqv? (sqrt 4/7) .7559289460184545)

;;; std::sqrt(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/sqrt

(check-eqv? (sqrt +0.0+0.0i) +0.0+0.0i)
(check-eqv? (sqrt -0.0+0.0i) +0.0+0.0i)

(check-eqv? (sqrt +nan.0+inf.0i) +inf.0+inf.0i)
(check-eqv? (sqrt +200.0+inf.0i) +inf.0+inf.0i)

(check-true (nan? (real-part (sqrt +2.0+nan.0i))))
(check-true (nan? (imag-part (sqrt +2.0+nan.0i))))

(check-eqv? (sqrt -inf.0+2.0i) +0.0+inf.0i)

(check-eqv? (sqrt +inf.0+2.0i) +inf.0+0.0i)

(check-true (nan? (real-part (sqrt -inf.0+nan.0i))))
(check-eqv?  (abs (imag-part (sqrt -inf.0+nan.0i))) +inf.0)

(check-eqv?       (real-part (sqrt +inf.0+nan.0i)) +inf.0)
(check-true (nan? (imag-part (sqrt +inf.0+nan.0i))))

(check-true (nan? (real-part (sqrt +nan.0+2.0i))))
(check-true (nan? (imag-part (sqrt +nan.0+2.0i))))

(check-true (nan? (real-part (sqrt +nan.0+nan.0i))))
(check-true (nan? (imag-part (sqrt +nan.0+nan.0i))))

(let ((args '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0 +inf.0 -inf.0)))
  (for-each (lambda (x)
              (for-each (lambda (y)
                          (let ((z (make-rectangular x y)))
                            (check-eqv? (sqrt (conjugate z))
                                        (conjugate (sqrt z)))))
                        args))
            args))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (sqrt #\c)))

