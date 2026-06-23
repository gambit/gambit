(include "#.scm")

;;; Test special values

(test-eqv 0 (tanh 0))
(test-eqv (imag-part (tan +i)) (tanh 1))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (tanh 1e-30+1e-40i))

;;; Tests derived from https://github.com/racket/racket/issues/3324

(test-assert (eq? #f (zero? (imag-part (tanh 300+20i)))))
(test-assert
 (eq? #t
      (rational?
       (imag-part (tanh 266.42844752772896+1.3482698511467367e308i)))))

;;; https://en.cppreference.com/w/cpp/numeric/complex/tanh

(test-eqv 0.+0.i (tanh 0.+0.i))

(test-assert (eq? #t (nan? (real-part (tanh 1.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (tanh 1.+nan.0i)))))

;; (check-eqv?       (real-part (tanh +0.+nan.0i)) 0.0) GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (tanh 0.+nan.0i)))))

(test-assert (eq? #t (nan? (real-part (tanh 1.+inf.0i)))))
(test-assert (eq? #t (nan? (imag-part (tanh 1.+inf.0i)))))

;; (check-eqv?       (real-part (tanh +0.+inf.0i)) 0.0) GOT +nan.0
(test-assert (eq? #t (nan? (imag-part (tanh 0.+inf.0i)))))

(test-eqv 1.+0.i (tanh +inf.0+1.i))

(test-eqv 1. (real-part (tanh +inf.0+inf.0i)))
(test-eqv 0. (abs (imag-part (tanh +inf.0+inf.0i))))

(test-eqv 1. (real-part (tanh +inf.0+nan.0i)))
(test-eqv 0. (abs (imag-part (tanh +inf.0+nan.0i))))

(test-assert (eq? #t (nan? (real-part (tanh +nan.0+0.i)))))
;; (check-eqv?       (imag-part (tanh +nan.0+0.i)) 0.) GOT +nan.0

(test-assert (eq? #t (nan? (real-part (tanh +nan.0+1.i)))))
(test-assert (eq? #t (nan? (imag-part (tanh +nan.0+1.i)))))

(test-assert (eq? #t (nan? (real-part (tanh +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (tanh +nan.0+nan.0i)))))

(define (test-tanh z)
  ;; avoid infinity / infinity
  (cond ((< 1 (real-part z)) (/ (- 1 (exp (* -2 z))) (+ 1 (exp (* -2 z)))))
        ((< (real-part z) -1) (/ (- (exp (* 2 z)) 1) (+ (exp (* 2 z)) 1)))
        (else (/ (sinh z) (cosh z)))))

(for-each
 (lambda (x)
   (for-each
    (lambda (y)
      (let ((z (make-rectangular x y)))
        (test-approximate (test-tanh z) (tanh z) 1e-12)
        (test-eqv (- (tanh z)) (tanh (- z)))
        (test-eqv (conjugate (tanh z)) (tanh (conjugate z)))))
    '(0. -0. .5 -.5 1. -1. 2. -2.)))
 ;; no infinite imaginary parts
 '(0. -0. .5 -.5 1. -1. 2. -2. +inf.0 -inf.0))

;;; Test exceptions

(test-error-tail type-exception? (tanh 'a))

