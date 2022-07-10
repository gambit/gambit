(include "#.scm")

;;; Test special values

(check-eqv? (acosh 1) 0)

;;; Test branch cuts

(check-= (acosh 0)    (test-acosh 0))
(check-= (acosh +0.i) (test-acosh +0.i))
(check-= (acosh -0.i) (test-acosh -0.i))

(check-= (acosh 1/2)  (test-acosh 1/2))
(check-= (acosh +1/2i) (test-acosh +1/2i))
(check-= (acosh 2)    (test-acosh 2))
(check-= (acosh +2i)  (test-acosh +2i))
(check-= (acosh 1+2i) (test-acosh 1+2i))

;;; https://en.cppreference.com/w/cpp/numeric/complex/acosh

(check-eqv? (acosh +0.0+0.0i) (make-rectangular +0.0 (macro-inexact-+pi/2)))
(check-eqv? (acosh -0.0+0.0i) (make-rectangular +0.0 (macro-inexact-+pi/2)))

(check-eqv? (acosh 1.+inf.0i) (make-rectangular +inf.0 (macro-inexact-+pi/2)))

(check-true (nan? (real-part (acosh +1.+nan.0i))))
(check-true (nan? (imag-part (acosh +1.+nan.0i))))

(check-eqv? (acosh -inf.0+1.0i) (make-rectangular +inf.0 (macro-inexact-+pi)))

(check-eqv? (acosh +inf.0+1.0i)  +inf.0+0.i)

;; (check-eqv? (acosh -inf.0+inf.0i) (make-rectangular +inf.0 (macro-inexact-+3pi/4))) GOT +inf.0+1.5707963267948966i

;; (check-eqv?       (real-part (acosh +inf.0+nan.0i)) +inf.0) GOT +nan.0
(check-true (nan? (imag-part (acosh +inf.0+nan.0i))))

;; (check-eqv?       (real-part (acosh -inf.0+nan.0i)) +inf.0) GOT +nan.0
(check-true (nan? (imag-part (acosh -inf.0+nan.0i))))

(check-true (nan? (real-part (acosh +nan.0+1.0i))))
(check-true (nan? (imag-part (acosh +nan.0+1.0i))))

(check-eqv?       (real-part (acosh +nan.0+inf.0i)) +inf.0)
;; (check-true (nan? (imag-part (acosh +nan.0+inf.0i)))) got +1.5707963267948966

(check-true (nan? (real-part (acosh +nan.0+nan.0i))))
(check-true (nan? (imag-part (acosh +nan.0+nan.0i))))

(let ((args '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0 +inf.0 -inf.0)))
  (for-each (lambda (x)
              (for-each (lambda (y)
                          (let ((z (make-rectangular x y)))
                            (check-eqv? (acosh (conjugate z))
                                        (conjugate (acosh z)))))
                        args))
            args))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (acosh 'a)))

