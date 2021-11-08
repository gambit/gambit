(include "#.scm")

(check-eqv? (denominator (/ -12 -10)) 5)
(check-eqv? (/ 0 1.0) 0)
(check-eqv? (/ 0 1.+1.i) 0)
