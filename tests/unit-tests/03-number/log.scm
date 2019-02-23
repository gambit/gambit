(include "#.scm")

;;; Test one-argument log

;;; Test special values

(check-eqv? (log 1) 0)

;;; Test branch cuts

(check-eqv? (log -1)  +3.141592653589793i)
(check-eqv? (log +i)  +1.5707963267948966i)
(check-eqv? (log -i)  -1.5707963267948966i)
(check-eqv? (log 0.+i)  0.+1.5707963267948966i)
(check-eqv? (log 0.-i)  0.-1.5707963267948966i)
(check-= (log -1+0.i) +3.141592653589793i)
(check-= (log -1-0.i) -3.141592653589793i)

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

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (log 2 #\c)))

(check-tail-exn type-exception? (lambda () (log #t 2)))

(check-tail-exn range-exception? (lambda () (log 0 2)))

(check-tail-exn range-exception? (lambda () (log 3 0)))

(check-tail-exn range-exception? (lambda () (log 2 1)))
