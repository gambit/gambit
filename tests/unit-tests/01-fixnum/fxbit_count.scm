(include "#.scm")

(test-eqv 0 (##fxbit-count -1))
(test-eqv 1 (##fxbit-count 1))
(test-eqv 6 (##fxbit-count 1000))

(test-eqv 29 (##fxbit-count 536870911))

(if (fixnum? 1152921504606846975)
    (test-eqv 60 (##fxbit-count 1152921504606846975)))

(test-eqv 0 (fxbit-count -1))
(test-eqv 1 (fxbit-count 1))
(test-eqv 6 (fxbit-count 1000))

(test-eqv 29 (fxbit-count 536870911))

(if (fixnum? 1152921504606846975)
    (test-eqv 60 (fxbit-count 1152921504606846975)))

(test-error-tail wrong-number-of-arguments-exception? (fxbit-count))
(test-error-tail wrong-number-of-arguments-exception? (fxbit-count 1 1))

(test-error-tail type-exception? (fxbit-count 0.0))
(test-error-tail type-exception? (fxbit-count 0.5))
(test-error-tail type-exception? (fxbit-count 1/2))
