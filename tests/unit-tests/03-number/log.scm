(include "#.scm")

;;; Test one-argument log

;;; Test special values

(test-eqv 0 (log 1))

;;; Test branch cuts

(test-eqv (make-rectangular 0 (macro-inexact-+pi)) (log -1))
(test-eqv (make-rectangular 0 (macro-inexact-+pi/2)) (log +i))
(test-eqv (make-rectangular 0 (macro-inexact--pi/2)) (log -i))
(test-eqv (make-rectangular 0. (macro-inexact-+pi/2)) (log 0.+i))
(test-eqv (make-rectangular 0. (macro-inexact--pi/2)) (log 0.-i))
(test-eqv (make-rectangular 0. (macro-inexact-+pi)) (log -1+0.i))
(test-eqv (make-rectangular 0. (macro-inexact--pi)) (log -1-0.i))

;;; Test exceptions

(test-error-tail type-exception? (log #\c))

(test-error-tail range-exception? (log 0))

;;; Test two-argument log

(test-approximate 1.5849625007211563 (log 3 2) 1e-12)

;;; Arguments where result is exact

(test-eqv 112121 (log (expt 2 112121) 2))
(test-eqv -1 (log 2 1/2))
(test-eqv -1 (log 1/2 2))
(test-eqv 1/3 (log 2 8))

;;; C99 real tests
;;; https://en.cppreference.com/w/cpp/numeric/math/log

;;; If the argument is ±0, -∞ is returned and FE_DIVBYZERO is raised.
(test-eqv -inf.0 (log 0.))
;;; (check-eqv? (log -0.) -inf.0)    ;; C99
(test-approximate -inf.0+3.141592653589793i (log -0.) 1e-12)
;; R7RS

;;; If the argument is 1, +0 is returned
(test-eqv 0. (log 1.))

;;; If the argument is negative, NaN is returned and FE_INVALID is raised.
;;; This is true for fllog, not log

;;; If the argument is +∞, +∞ is returned
(test-eqv +inf.0 (log +inf.0))

;;; If the argument is NaN, NaN is returned
(test-assert (eq? #t (nan? (log +nan.0))))

;;; C99 complex tests
;;; https://en.cppreference.com/w/cpp/numeric/complex/log

;;; If z is -0+0i, the result is -∞+πi and FE_DIVBYZERO is raised
(test-eqv (make-rectangular -inf.0 (macro-inexact-+pi)) (log -0.+0.i))

;;; If z is +0+0i, the result is -∞+0i and FE_DIVBYZERO is raised
(test-eqv -inf.0+0.i (log 0.+0.i))

;;; If z is x+∞i (for any finite x), the result is +∞+πi/2
(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi/2)) (log 2.+inf.0i))

;;; If z is x+NaNi (for any finite x), the result is NaN+NaNi and FE_INVALID may be raised
(test-assert (eq? #t (nan? (real-part (log 2.+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (log 2.+nan.0i)))))

;;; If z is -∞+yi (for any finite positive y), the result is +∞+πi
(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi)) (log -inf.0+2.i))

;;; If z is +∞+yi (for any finite positive y), the result is +∞+0i
(test-eqv +inf.0+0.i (log +inf.0+2.i))

;;; If z is -∞+∞i, the result is +∞+3πi/4
(test-eqv (make-rectangular +inf.0 (macro-inexact-+3pi/4)) (log -inf.0+inf.0i))

;;; If z is +∞+∞i, the result is +∞+πi/4
(test-eqv (make-rectangular +inf.0 (macro-inexact-+pi/4)) (log +inf.0+inf.0i))

;;; If z is ±∞+NaNi, the result is +∞+NaNi
(test-eqv +inf.0 (real-part (log +inf.0+nan.0i)))
(test-assert (eq? #t (nan? (imag-part (log +inf.0+nan.0i)))))

(test-eqv +inf.0 (real-part (log -inf.0+nan.0i)))
(test-assert (eq? #t (nan? (imag-part (log -inf.0+nan.0i)))))

;;; If z is NaN+yi (for any finite y), the result is NaN+NaNi and FE_INVALID may be raised
(test-assert (eq? #t (nan? (real-part (log +nan.0+2.i)))))
(test-assert (eq? #t (nan? (imag-part (log +nan.0+2.i)))))

;;; If z is NaN+∞i, the result is +∞+NaNi
(test-eqv +inf.0 (real-part (log +nan.0+inf.0i)))
(test-assert (eq? #t (nan? (imag-part (log +nan.0+inf.0i)))))

;;; If z is NaN+NaNi, the result is NaN+NaNi
(test-assert (eq? #t (nan? (real-part (log +nan.0+nan.0i)))))
(test-assert (eq? #t (nan? (imag-part (log +nan.0+nan.0i)))))

;;; std::log(std::conj(z)) == std::conj(std::log(z))

(let ((args '(0. -0. 2. -2. +inf.0 -inf.0)))
  (for-each
   (lambda (x)
     (for-each
      (lambda (y)
        (let ((z (make-rectangular x y)))
          (test-eqv (conjugate (log z)) (log (conjugate z)))))
      args))
   args))

;;; Test exceptions

(test-error-tail type-exception? (log 2 #\c))

(test-error-tail type-exception? (log #t 2))

(test-error-tail range-exception? (log 0 2))

(test-error-tail range-exception? (log 3 0))

(test-error-tail range-exception? (log 2 1))
