(include "#.scm")

(test-eqv 0. (##floor 0.5))
(test-eqv 0 (##floor 1/2))
(test-eqv -2. (##floor -1.5))
(test-eqv -2 (##floor -3/2))

(test-eqv 0. (floor 0.5))
(test-eqv 0 (floor 1/2))
(test-eqv -2. (floor -1.5))
(test-eqv -2 (floor -3/2))


(test-error-tail type-exception? (floor 'a))

(test-error-tail wrong-number-of-arguments-exception? (floor))
(test-error-tail wrong-number-of-arguments-exception? (floor 1. 1.))
