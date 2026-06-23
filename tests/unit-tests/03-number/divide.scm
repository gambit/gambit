(include "#.scm")

(test-eqv 5 (denominator (/ -12 -10)))
(test-eqv 0 (/ 0 1.))
(test-eqv 0 (/ 0 1.+1.i))
(test-eqv -2/9 (/ 2/3 -3))
(test-eqv -2/9 (/ -2/3 3))
(test-eqv -9 (/ -6 2/3))
(test-eqv -9 (/ 6 -2/3))
