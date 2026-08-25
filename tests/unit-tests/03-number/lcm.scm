(include "#.scm")

(test-error-tail type-exception? (lcm 1 'a))
(test-error-tail type-exception? (lcm 'a 1))
(test-error-tail type-exception? (lcm 3/2 1))
(test-error-tail type-exception? (lcm 1 3/2))
(test-error-tail type-exception? (lcm 1.5 1))
(test-error-tail type-exception? (lcm 1 1.5))
(test-error-tail type-exception? (lcm 1+0.i 1))
(test-error-tail type-exception? (lcm 1 1+0.i))

(test-eqv 30 (lcm 15 6))

(test-eqv (expt 15. 5) (lcm (expt 3 5) (expt 5. 5)))
(test-eqv (expt 15. 5) (lcm (expt 3. 5) (expt 5. 5)))
(test-eqv (expt 15. 5) (lcm (expt 3. 5) (expt 5 5)))


(test-eqv 0 (lcm 0 1.))
(test-eqv 0 (lcm 1. 0))
(test-eqv 0. (lcm 1 0.))
(test-eqv 0. (lcm 0. 1))
