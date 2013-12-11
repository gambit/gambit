(include "#.scm")

;;; Test special values

(check-eqv? (log 1) 0)

;;; Test branch cuts

(check-eqv? (log -1)  +3.141592653589793i)
(check-= (log -1+0.i) +3.141592653589793i)
(check-= (log -1-0.i) -3.141592653589793i)
