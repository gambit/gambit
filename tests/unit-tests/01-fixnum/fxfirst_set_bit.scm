(include "#.scm")

(test-eqv 0 (##fxfirst-set-bit 1))
(test-eqv 2 (##fxfirst-set-bit 100))
(test-eqv 3 (##fxfirst-set-bit -1000))

(test-eqv 0 (fxfirst-set-bit 1))
(test-eqv 2 (fxfirst-set-bit 100))
(test-eqv 3 (fxfirst-set-bit -1000))

(test-error-tail type-exception? (fxfirst-set-bit 0.))
(test-error-tail type-exception? (fxfirst-set-bit .5))
(test-error-tail type-exception? (fxfirst-set-bit 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxfirst-set-bit))
(test-error-tail wrong-number-of-arguments-exception? (fxfirst-set-bit 1 1))
