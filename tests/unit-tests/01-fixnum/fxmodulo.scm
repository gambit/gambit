(include "#.scm")

(test-eqv 0 (##fxmodulo 3 1))
(test-eqv 1 (##fxmodulo 3 2))
(test-eqv 0 (##fxmodulo 3 3))

(test-eqv 0 (fxmodulo 3 1))
(test-eqv 1 (fxmodulo 3 2))
(test-eqv 0 (fxmodulo 3 3))

(test-error-tail divide-by-zero-exception? (fxmodulo 1 0))

(test-error-tail type-exception? (fxmodulo 1 0.))
(test-error-tail type-exception? (fxmodulo .5 1))
(test-error-tail type-exception? (fxmodulo 1 .5))
(test-error-tail type-exception? (fxmodulo 1 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxmodulo))
(test-error-tail wrong-number-of-arguments-exception? (fxmodulo 1 1 1))
