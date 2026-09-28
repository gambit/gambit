(include "#.scm")

(test-eqv 24. (##flscalbn 1.5 4))
(test-eqv 0.375 (##flscalbn 3. -3))
(test-eqv -24. (##flscalbn -1.5 4))
(test-eqv -0.375 (##flscalbn -3. -3))

(test-eqv 24. (flscalbn 1.5 4))
(test-eqv 0.375 (flscalbn 3. -3))
(test-eqv -24. (flscalbn -1.5 4))
(test-eqv -0.375 (flscalbn -3. -3))

(test-error-tail type-exception? (flscalbn 0 1))
(test-error-tail type-exception? (flscalbn 1/2 1))
(test-error-tail type-exception? (flscalbn 'a 1))
(test-error-tail type-exception? (flscalbn 1. 0.))
(test-error-tail type-exception? (flscalbn 1. 1/2))
(test-error-tail type-exception? (flscalbn 1. 'a))

(test-error-tail wrong-number-of-arguments-exception? (flscalbn))
(test-error-tail wrong-number-of-arguments-exception? (flscalbn 1.))
(test-error-tail wrong-number-of-arguments-exception? (flscalbn 1. 1 1))
