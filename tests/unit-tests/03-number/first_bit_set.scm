(include "#.scm")

(test-eqv 0 (##fxfirst-set-bit 1))
(test-eqv 2 (##fxfirst-set-bit 100))
(test-eqv 3 (##fxfirst-set-bit -1000))
(test-eqv 20 (##fxfirst-set-bit 55574528))
(test-eqv 50 (##fxfirst-set-bit 59672695062659072))
(test-eqv 100 (##first-set-bit 67185481812096158279325269884928))

(test-eqv 0 (fxfirst-set-bit 1))
(test-eqv 2 (fxfirst-set-bit 100))
(test-eqv 3 (fxfirst-set-bit -1000))
(test-eqv 20 (fxfirst-set-bit 55574528))
(test-eqv 50 (fxfirst-set-bit 59672695062659072))
(test-eqv 100 (first-set-bit 67185481812096158279325269884928))

(test-error-tail wrong-number-of-arguments-exception? (fxfirst-set-bit))
(test-error-tail wrong-number-of-arguments-exception? (fxfirst-set-bit 1 1))

(test-error-tail type-exception? (fxfirst-set-bit 0.0))
(test-error-tail type-exception? (fxfirst-set-bit 0.5))
(test-error-tail type-exception? (fxfirst-set-bit 1/2))
