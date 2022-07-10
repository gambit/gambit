(include "#.scm")

;;; Test special values

(check-eqv? (atanh 0) 0)

;;; Test branch cuts

(check-= (atanh 2)      (test-atanh 2))
(check-= (atanh 2+0.i)  (test-atanh 2+0.i))
(check-= (atanh 2-0.i)  (test-atanh 2-0.i))
(check-= (atanh -2)     (test-atanh -2))
(check-= (atanh -2+0.i) (test-atanh -2+0.i))
(check-= (atanh -2-0.i) (test-atanh -2-0.i))

;;; Test for accuracy near 0

(check-eqv? (atanh 1e-30+1e-40i) 1e-30+1e-40i)

;;; CPP reference std::atanh(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/atanh

(check-eqv? (atanh +0.+0.i)    +0.+0.i)

;; (check-eqv?       (real-part (atanh +0.+nan.0i)) 0.)  ;; GOT +nan.0
(check-true (nan? (imag-part (atanh +0.+nan.0i))))

;; (check-eqv? (atanh +1.+0.i)    +inf.0+0.i)  ;; GOT +inf.0+.7853981633974483i

(check-eqv? (atanh +2.+inf.0i) (make-rectangular +0. (macro-inexact-+pi/2)))

(check-true (nan? (real-part (atanh +1.+nan.0i))))
(check-true (nan? (imag-part (atanh +1.+nan.0i))))

(check-eqv? (atanh +inf.0+2.i)    (make-rectangular +0. (macro-inexact-+pi/2)))

(check-eqv? (atanh +inf.0+inf.0i) (make-rectangular +0. (macro-inexact-+pi/2)))

(check-eqv?       (real-part (atanh +inf.0+nan.0i)) 0.)
;; (check-true (nan? (imag-part (atanh +inf.0+nan.0i))))  ;; GOT pi/2

(check-true (nan? (real-part (atanh +nan.0+2.i))))
(check-true (nan? (imag-part (atanh +nan.0+2.i))))

(check-eqv? (atanh +nan.0+inf.0i) (make-rectangular +0. (macro-inexact-+pi/2)))

(check-true (nan? (real-part (atanh +nan.0+nan.0i))))
(check-true (nan? (imag-part (atanh +nan.0+nan.0i))))

(let ((args '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0 +inf.0 -inf.0)))
  (for-each (lambda (x)
              (for-each (lambda (y)
                          (let ((z (make-rectangular x y)))
                            (check-eqv? (atanh (- z))
                                        (- (atanh z)))
                            (check-eqv? (atanh (conjugate z))
                                        (conjugate (atanh z)))))
                        args))
            args))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (atanh 'a)))

(check-tail-exn range-exception? (lambda () (atanh -1)))
(check-tail-exn range-exception? (lambda () (atanh +1)))

