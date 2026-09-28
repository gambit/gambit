(include "#.scm")

(test-eqv 0. (##flsquare 0.))
(test-eqv 1. (##flsquare 1.))
(test-eqv 4. (##flsquare 2.))
(test-eqv .25 (##flsquare .5))

(test-eqv 0. (flsquare 0.))
(test-eqv 1. (flsquare 1.))
(test-eqv 4. (flsquare 2.))
(test-eqv .25 (flsquare .5))

(test-error-tail type-exception? (flsquare 0))
(test-error-tail type-exception? (flsquare 1/2))
(test-error-tail type-exception? (flsquare 'a))

(test-error-tail wrong-number-of-arguments-exception? (flsquare))
(test-error-tail wrong-number-of-arguments-exception? (flsquare 1. 1.))
