(include "#.scm")

(test-eqv 0 (##first-set-bit 1))
(test-eqv 2 (##first-set-bit 100))
(test-eqv 3 (##first-set-bit -1000))
(test-eqv 20 (##first-set-bit 55574528))
(test-eqv 50 (##first-set-bit 59672695062659072))
(test-eqv 100 (##first-set-bit 67185481812096158279325269884928))

(test-eqv 0 (first-set-bit 1))
(test-eqv 2 (first-set-bit 100))
(test-eqv 3 (first-set-bit -1000))
(test-eqv 20 (first-set-bit 55574528))
(test-eqv 50 (first-set-bit 59672695062659072))
(test-eqv 100 (first-set-bit 67185481812096158279325269884928))

(test-error-tail wrong-number-of-arguments-exception? (first-set-bit))
(test-error-tail wrong-number-of-arguments-exception? (first-set-bit 1 1))

(test-error-tail type-exception? (first-set-bit 0.0))
(test-error-tail type-exception? (first-set-bit 0.5))
(test-error-tail type-exception? (first-set-bit 1/2))
