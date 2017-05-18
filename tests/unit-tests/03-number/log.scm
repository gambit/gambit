(include "#.scm")

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

