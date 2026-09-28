(include "#.scm")

(test-eqv -2 (##flilogb 0.25))   ;; examples found online
(test-eqv 1 (##flilogb 2.))
(test-eqv 26 (##flilogb 100000000.))

(test-eqv -2 (flilogb 0.25))
(test-eqv 1 (flilogb 2.))
(test-eqv 26 (flilogb 100000000.))

(test-error-tail type-exception? (flilogb 0))
(test-error-tail type-exception? (flilogb 1/2))
(test-error-tail type-exception? (flilogb 'a))

(test-error-tail wrong-number-of-arguments-exception? (flilogb))
(test-error-tail wrong-number-of-arguments-exception? (flilogb 1. 1.))
