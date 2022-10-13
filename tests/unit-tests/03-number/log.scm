(include "#.scm")

;;; Test one-argument log

;;; Test special values

(check-eqv? (log 1) 0)

;;; Test branch cuts

(check-eqv? (log -1)  (make-rectangular 0 (macro-inexact-+pi)))
(check-eqv? (log +i)  (make-rectangular 0 (macro-inexact-+pi/2)))
(check-eqv? (log -i)  (make-rectangular 0 (macro-inexact--pi/2)))
(check-eqv? (log 0.+i) (make-rectangular 0. (macro-inexact-+pi/2)))
(check-eqv? (log 0.-i) (make-rectangular 0. (macro-inexact--pi/2)))
(check-eqv? (log -1+0.i) (make-rectangular 0. (macro-inexact-+pi)))
(check-eqv? (log -1-0.i) (make-rectangular 0. (macro-inexact--pi)))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (log #\c)))

(check-tail-exn range-exception? (lambda () (log 0)))

;;; Test two-argument log

(check-= (log 3 2) 1.5849625007211563)

;;; Arguments where result is exact

(check-eqv? (log (expt 2 112121) 2) 112121)
(check-eqv? (log 2 1/2) -1)
(check-eqv? (log 1/2 2) -1)
(check-eqv? (log 2 8) 1/3)

;;; C99 tests

;;; If z is -0+0i, the result is -∞+πi and FE_DIVBYZERO is raised
(check-eqv? (log -0.+0.i) (make-rectangular -inf.0 (macro-inexact-+pi)))

;;; If z is +0+0i, the result is -∞+0i and FE_DIVBYZERO is raised
(check-eqv? (log +0.+0.i) -inf.0+0.i)

;;; If z is x+∞i (for any finite x), the result is +∞+πi/2
(check-eqv? (log 2.+inf.0i) (make-rectangular +inf.0 (macro-inexact-+pi/2)))

;;; If z is x+NaNi (for any finite x), the result is NaN+NaNi and FE_INVALID may be raised
(check-true (nan? (real-part (log 2.+nan.0i))))
(check-true (nan? (imag-part (log 2.+nan.0i))))

;;; If z is -∞+yi (for any finite positive y), the result is +∞+πi
(check-eqv? (log -inf.0+2.i) (make-rectangular +inf.0 (macro-inexact-+pi)))

;;; If z is +∞+yi (for any finite positive y), the result is +∞+0i
(check-eqv? (log +inf.0+2.i) +inf.0+0.i)

;;; If z is -∞+∞i, the result is +∞+3πi/4
(check-eqv? (log -inf.0+inf.0i) (make-rectangular +inf.0 (macro-inexact-+3pi/4)))

;;; If z is +∞+∞i, the result is +∞+πi/4
(check-eqv? (log +inf.0+inf.0i) (make-rectangular +inf.0 (macro-inexact-+pi/4)))

;;; If z is ±∞+NaNi, the result is +∞+NaNi
(check-eqv? (real-part (log +inf.0+nan.0i)) +inf.0)
(check-true (nan? (imag-part (log +inf.0+nan.0i))))

(check-eqv? (real-part (log -inf.0+nan.0i)) +inf.0)
(check-true (nan? (imag-part (log -inf.0+nan.0i))))

;;; If z is NaN+yi (for any finite y), the result is NaN+NaNi and FE_INVALID may be raised
(check-true (nan? (real-part (log +nan.0+2.i))))
(check-true (nan? (imag-part (log +nan.0+2.i))))

;;; If z is NaN+∞i, the result is +∞+NaNi
(check-eqv? (real-part (log +nan.0+inf.0i)) +inf.0)
(check-true (nan? (imag-part (log +nan.0+inf.0i))))

;;; If z is NaN+NaNi, the result is NaN+NaNi
(check-true (nan? (real-part (log +nan.0+nan.0i))))
(check-true (nan? (imag-part (log +nan.0+nan.0i))))

;;; std::log(std::conj(z)) == std::conj(std::log(z))

(let ((args '(+0. -0. +2.0 -2.0 +inf.0 -inf.0)))
  (for-each (lambda (x)
              (for-each (lambda (y)
                          (let ((z (make-rectangular x y)))
                            (check-eqv? (log (conjugate z))
                                        (conjugate (log z)))))
                        args))
            args))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (log 2 #\c)))

(check-tail-exn type-exception? (lambda () (log #t 2)))

(check-tail-exn range-exception? (lambda () (log 0 2)))

(check-tail-exn range-exception? (lambda () (log 3 0)))

(check-tail-exn range-exception? (lambda () (log 2 1)))
