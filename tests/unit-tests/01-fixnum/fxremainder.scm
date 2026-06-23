(include "#.scm")

(test-eqv 0 (##fxremainder 3 1))
(test-eqv 1 (##fxremainder 3 2))
(test-eqv 0 (##fxremainder 3 3))

(test-eqv 0 (fxremainder 3 1))
(test-eqv 1 (fxremainder 3 2))
(test-eqv 0 (fxremainder 3 3))

(test-error-tail divide-by-zero-exception? (fxremainder 1 0))

(test-error-tail type-exception? (fxremainder 1 0.))
(test-error-tail type-exception? (fxremainder .5 1))
(test-error-tail type-exception? (fxremainder 1 .5))
(test-error-tail type-exception? (fxremainder 1 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxremainder))
(test-error-tail wrong-number-of-arguments-exception? (fxremainder 1 1 1))
