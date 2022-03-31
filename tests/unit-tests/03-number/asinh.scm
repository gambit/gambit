(include "#.scm")

;;; Test special values

(check-eqv? (asinh 0) 0)

;;; Test branch cuts

(check-= (asinh -2i)    (test-asinh -2i))
(check-= (asinh +0.-2i) (test-asinh 0.-2i))
(check-= (asinh -0.-2i) (test-asinh -0.-2i))
(check-= (asinh +2i)    (test-asinh +2i))
(check-= (asinh +0.+2i) (test-asinh 0.+2i))
(check-= (asinh -0.+2i) (test-asinh -0.+2i))

;;; Test for accuracy near 0

(check-eqv? (asinh 1e-30+1e-40i) 1e-30+1e-40i)

;;; CPP reference std:asinh(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/asinh

(check-eqv? (asinh +0.+0.i) +0.+0.i)

(check-eqv? (asinh 2.+inf.0i) (make-rectangular +inf.0 (macro-inexact-+pi/2)))

(check-true (nan? (real-part (asinh 2.+nan.0i))))
(check-true (nan? (imag-part (asinh 2.+nan.0i))))

(check-eqv? (asinh +inf.0+2.0i) +inf.0+0.0i)

(check-eqv? (asinh +inf.0+inf.0i) (make-rectangular +inf.0 (macro-inexact-+pi/4)))

(check-eqv?       (real-part (asinh +inf.0+nan.0i)) +inf.0)
(check-true (nan? (imag-part (asinh +inf.0+nan.0i))))

(check-true (nan? (real-part (asinh +nan.0+0.0i))))
;; (check-eqv?       (imag-part (asinh +nan.0+0.0i)) +0.)  GOT +nan.0

(check-true (nan? (real-part (asinh +nan.0+1.0i))))
(check-true (nan? (imag-part (asinh +nan.0+1.0i))))

;; (check-eqv?  (abs (real-part (asinh +nan.0+inf.0i))) +inf.0) GOT +nan.0
(check-true (nan? (imag-part (asinh +nan.0+inf.0i))))

(check-true (nan? (real-part (asinh +nan.0+nan.0i))))
(check-true (nan? (imag-part (asinh +nan.0+nan.0i))))

(let ((args '(+0. -0. +0.5 -0.5 +1. -1. +2.0 -2.0 +inf.0 -inf.0)))
  (for-each (lambda (x)
              (for-each (lambda (y)
                          (let ((z (make-rectangular x y)))
                            (check-eqv? (asinh (- z))
                                        (- (asinh z)))
                            (check-eqv? (asinh (conjugate z))
                                        (conjugate (asinh z)))))
                        args))
            args))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (asinh 'a)))

