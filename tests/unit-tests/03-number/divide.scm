(include "#.scm")

(check-eqv? (denominator (/ -12 -10)) 5)
(check-eqv? (/ 0 1.0) 0)
(check-eqv? (/ 0 1.+1.i) 0)
(check-eqv? (/ 2/3 -3) -2/9)
(check-eqv? (/ -2/3 3) -2/9)
(check-eqv? (/ -6 2/3) -9)
(check-eqv? (/ 6 -2/3) -9)
