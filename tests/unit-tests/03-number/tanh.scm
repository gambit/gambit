(include "#.scm")

;;; Test special values

(check-eqv? (tanh 0) 0)
(check-eqv? (tanh 1) (imag-part (tan +i)))

;;; Test for accuracy near 0

(check-eqv? (tanh 1e-30+1e-40i) 1e-30+1e-40i)

;;; https://en.cppreference.com/w/cpp/numeric/complex/tanh

(check-eqv? (tanh +0.+0.i) +0.+0.i)

(check-true (nan? (real-part (tanh +1.+nan.0i))))
(check-true (nan? (imag-part (tanh +1.+nan.0i))))

;; (check-eqv?       (real-part (tanh +0.+nan.0i)) 0.0) GOT +nan.0
(check-true (nan? (imag-part (tanh +0.+nan.0i))))

(check-true (nan? (real-part (tanh +1.+inf.0i))))
(check-true (nan? (imag-part (tanh +1.+inf.0i))))

;; (check-eqv?       (real-part (tanh +0.+inf.0i)) 0.0) GOT +nan.0
(check-true (nan? (imag-part (tanh +0.+inf.0i))))

(check-eqv? (tanh +inf.0+1.0i) +1.0+0.i)

(check-eqv?      (real-part (tanh +inf.0+inf.0i))  1.0)
(check-eqv? (abs (imag-part (tanh +inf.0+inf.0i))) 0.0)

(check-eqv?      (real-part (tanh +inf.0+nan.0i))  1.0)
(check-eqv? (abs (imag-part (tanh +inf.0+nan.0i))) 0.0)

(check-true (nan? (real-part (tanh +nan.0+0.i))))
;; (check-eqv?       (imag-part (tanh +nan.0+0.i)) 0.) GOT +nan.0

(check-true (nan? (real-part (tanh +nan.0+1.i))))
(check-true (nan? (imag-part (tanh +nan.0+1.i))))

(check-true (nan? (real-part (tanh +nan.0+nan.0i))))
(check-true (nan? (imag-part (tanh +nan.0+nan.0i))))

(define (test-tanh z) (/ (sinh z) (cosh z)))

(for-each (lambda (x)
            (for-each (lambda (y)
                        (let ((z (make-rectangular x y)))
                          (pp z)
                          (check-= (tanh z) (test-tanh z))
                          (check-eqv? (tanh (- z))
                                      (- (tanh z)))
                          (check-eqv? (tanh (conjugate z))
                                      (conjugate (tanh z)))))
                      '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0)))  ;; no infinite imaginary parts
          '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0 +inf.0 -inf.0))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (tanh 'a)))

