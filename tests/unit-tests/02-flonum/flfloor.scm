(include "#.scm")

(test-eqv 0. (##flfloor 0.5))
(test-eqv -2. (##flfloor -1.5))

(test-eqv 0. (flfloor 0.5))
(test-eqv -2. (flfloor -1.5))

(test-error-tail type-exception? (flfloor 0))
(test-error-tail type-exception? (flfloor 1/2))
(test-error-tail type-exception? (flfloor 'a))

(test-error-tail wrong-number-of-arguments-exception? (flfloor))
(test-error-tail wrong-number-of-arguments-exception? (flfloor 1. 1.))
