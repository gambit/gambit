(include "#.scm")

;;; Test special values

(test-eqv 0 (acosh 1))

;;; Test branch cuts

(test-approximate (test-acosh 0) (acosh 0) 1e-12)
(test-approximate (test-acosh +0.i) (acosh +0.i) 1e-12)
(test-approximate (test-acosh -0.i) (acosh -0.i) 1e-12)

(test-approximate (test-acosh 1/2) (acosh 1/2) 1e-12)
(test-approximate (test-acosh +1/2i) (acosh +1/2i) 1e-12)
(test-approximate (test-acosh 2) (acosh 2) 1e-12)
(test-approximate (test-acosh +2i) (acosh +2i) 1e-12)
(test-approximate (test-acosh 1+2i) (acosh 1+2i) 1e-12)

;;; https://en.cppreference.com/w/cpp/numeric/complex/acosh

(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (acosh 0.+0.i))
(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (acosh -0.+0.i))

(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi/2)) (acosh 1.+inf.0i))

(test-assert (eq? #t (nan? (real-part (acosh 1.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (acosh 1.+nan.0i)))))

(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi)) (acosh -inf.0+1.i))

(test-eqv +inf.0+0.i (acosh +inf.0+1.i))

;; (check-eqv? (acosh -inf.0+inf.0i) (make-rectangular +inf.0 (macro-inexact-+3pi/4))) GOT +inf.0+1.5707963267948966i

;; (check-eqv?       (real-part (acosh +inf.0+nan.0i)) +inf.0) GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (acosh +inf.0+nan.0i)))))

;; (check-eqv?       (real-part (acosh -inf.0+nan.0i)) +inf.0) GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (acosh -inf.0+nan.0i)))))

(test-assert (eq? #t (nan? (real-part (acosh +nan.0+1.i)))))
(test-assert (eq? #t (nan? (imag-part (acosh +nan.0+1.i)))))

(test-eqv +inf.0 (real-part (acosh +nan.0+inf.0i)))
;; (check-true (nan? (imag-part (acosh +nan.0+inf.0i)))) got +1.5707963267948966

(test-assert (eq? #t (nan? (real-part (acosh +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (acosh +nan.0+nan.0i)))))

(let ((args '(0. -0. .5 -.5 1. -1. 2. -2. +inf.0 -inf.0)))
  (for-each
   (lambda (x)
     (for-each
      (lambda (y)
        (let ((z (make-rectangular x y)))
          (test-eqv (conjugate (acosh z)) (acosh (conjugate z)))))
      args))
   args))

;;; Test exceptions

(test-error-tail type-exception? (acosh 'a))

