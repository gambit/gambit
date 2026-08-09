(include "#.scm")

(test-eqv 1 (##fxif 0 -1 1))
(test-eqv 1 (##fxif -1 1 0))
(test-eqv -2 (##fxif 1 0 -1))

(test-eqv 1 (fxif 0 -1 1))
(test-eqv 1 (fxif -1 1 0))
(test-eqv -2 (fxif 1 0 -1))

(test-error-tail wrong-number-of-arguments-exception? (fxif))
(test-error-tail wrong-number-of-arguments-exception? (fxif 1 1 1 1))

(test-error-tail type-exception? (fxif 1 1 0.))
(test-error-tail type-exception? (fxif .5 1 1))
(test-error-tail type-exception? (fxif 1 .5 1))
(test-error-tail type-exception? (fxif 1 1 .5))
(test-error-tail type-exception? (fxif 1 1 1/2))
