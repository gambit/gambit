(include "#.scm")

;;; Test special values

(test-eqv 0 (asinh 0))

;;; Test branch cuts

(test-approximate (test-asinh -2i) (asinh -2i) 1e-12)
(test-approximate (test-asinh 0.-2i) (asinh 0.-2i) 1e-12)
(test-approximate (test-asinh -0.-2i) (asinh -0.-2i) 1e-12)
(test-approximate (test-asinh +2i) (asinh +2i) 1e-12)
(test-approximate (test-asinh 0.+2i) (asinh 0.+2i) 1e-12)
(test-approximate (test-asinh -0.+2i) (asinh -0.+2i) 1e-12)

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (asinh 1e-30+1e-40i))

;;; CPP reference std:asinh(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/asinh

(test-eqv 0.+0.i (asinh 0.+0.i))

(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi/2)) (asinh 2.+inf.0i))

(test-assert (eq? #t (nan? (real-part (asinh 2.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (asinh 2.+nan.0i)))))

(test-eqv +inf.0+0.i (asinh +inf.0+2.i))

(test-eqv
 (make-rectangular +inf.0 (macro-inexact-+pi/4))
 (asinh +inf.0+inf.0i))

(test-eqv +inf.0 (real-part (asinh +inf.0+nan.0i)))
(test-assert (eq? #t (nan? (imag-part (asinh +inf.0+nan.0i)))))

(test-assert (eq? #t (nan? (real-part (asinh +nan.0+0.i)))))
;; (check-eqv?       (imag-part (asinh +nan.0+0.0i)) +0.)  GOT +nan.0

(test-assert (eq? #t (nan? (real-part (asinh +nan.0+1.i)))))
(test-assert (eq? #t (nan? (imag-part (asinh +nan.0+1.i)))))

;; (check-eqv?  (abs (real-part (asinh +nan.0+inf.0i))) +inf.0) GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (asinh +nan.0+inf.0i)))))

(test-assert (eq? #t (nan? (real-part (asinh +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (asinh +nan.0+nan.0i)))))

(let ((args '(0. -0. .5 -.5 1. -1. 2. -2. +inf.0 -inf.0)))
  (for-each
   (lambda (x)
     (for-each
      (lambda (y)
        (let ((z (make-rectangular x y)))
          (test-eqv (- (asinh z)) (asinh (- z)))
          (test-eqv (conjugate (asinh z)) (asinh (conjugate z)))))
      args))
   args))

;;; Test exceptions

(test-error-tail type-exception? (asinh 'a))

