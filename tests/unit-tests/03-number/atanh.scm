(include "#.scm")

;;; Test special values

(test-eqv 0 (atanh 0))

;;; Check exact vs inexact

(test-approximate (atanh .5) (atanh 1/2) 1e-12)
(test-approximate (atanh 2.) (atanh 2) 1e-12)

;;; Test branch cuts

(test-approximate (test-atanh 2) (atanh 2) 1e-12)
(test-approximate (test-atanh 2+0.i) (atanh 2+0.i) 1e-12)
(test-approximate (test-atanh 2-0.i) (atanh 2-0.i) 1e-12)
(test-approximate (test-atanh -2) (atanh -2) 1e-12)
(test-approximate (test-atanh -2+0.i) (atanh -2+0.i) 1e-12)
(test-approximate (test-atanh -2-0.i) (atanh -2-0.i) 1e-12)

(test-approximate (test-atanh 1.) (atanh 1.) 1e-12)
(test-approximate (test-atanh 1+0.i) (atanh 1+0.i) 1e-12)
;; test-atanh is not correct for 1.+0.i
(test-approximate (test-atanh 1-0.i) (atanh 1-0.i) 1e-12)
;; test-atanh is not correct for 1.-0.i

;;; Test for accuracy for large real x

(test-eqv (make-rectangular 0. (macro-inexact--pi/2)) (atanh +inf.0))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (atanh 1e-30+1e-40i))

;;; CPP reference std::atanh(std::complex)
;;; https://en.cppreference.com/w/cpp/numeric/complex/atanh

(test-eqv 0.+0.i (atanh 0.+0.i))

;; (check-eqv?       (real-part (atanh +0.+nan.0i)) 0.)  ;; GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (atanh 0.+nan.0i)))))

;; (check-eqv? (atanh +1.+0.i)    +inf.0+0.i)  ;; GOT +inf.0+.7853981633974483i

(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (atanh 2.+inf.0i))

(test-assert (eq? #t (nan? (real-part (atanh 1.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (atanh 1.+nan.0i)))))

(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (atanh +inf.0+2.i))

(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (atanh +inf.0+inf.0i))

(test-eqv 0. (real-part (atanh +inf.0+nan.0i)))
;; (check-true (nan? (imag-part (atanh +inf.0+nan.0i))))  ;; GOT pi/2

(test-assert (eq? #t (nan? (real-part (atanh +nan.0+2.i)))))
(test-assert (eq? #t (nan? (imag-part (atanh +nan.0+2.i)))))

(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (atanh +nan.0+inf.0i))

(test-assert (eq? #t (nan? (real-part (atanh +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (atanh +nan.0+nan.0i)))))

(let ((args '(0. -0. .5 -.5 1. -1. 2. -2. +inf.0 -inf.0)))
  (for-each
   (lambda (x)
     (for-each
      (lambda (y)
        (let ((z (make-rectangular x y)))
          (test-eqv (- (atanh z)) (atanh (- z)))
          (test-eqv (conjugate (atanh z)) (atanh (conjugate z)))))
      args))
   args))

;;; Test exceptions

(test-error-tail type-exception? (atanh 'a))

(test-error-tail range-exception? (atanh -1))
(test-error-tail range-exception? (atanh 1))

