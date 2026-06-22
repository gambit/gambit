(include "#.scm")

(test-eqv 0 (##integer-length 0))
(test-eqv 0 (##integer-length -1))

(test-eqv 29 (##integer-length -536870912))
(test-eqv 29 (##integer-length  536870911))

(test-eqv 60 (##integer-length -1152921504606846976))
(test-eqv 60 (##integer-length  1152921504606846975))

(test-eqv 94 (##integer-length 12345678901234567890123456789))

(test-eqv 0 (integer-length 0))
(test-eqv 0 (integer-length -1))

(test-eqv 29 (integer-length -536870912))
(test-eqv 29 (integer-length  536870911))

(test-eqv 60 (integer-length -1152921504606846976))
(test-eqv 60 (integer-length  1152921504606846975))

(test-eqv 94 (integer-length 12345678901234567890123456789))

(test-error-tail wrong-number-of-arguments-exception? (integer-length))
(test-error-tail wrong-number-of-arguments-exception? (integer-length 1 1))

(test-error-tail type-exception? (integer-length 0.0))
(test-error-tail type-exception? (integer-length 0.5))
(test-error-tail type-exception? (integer-length 1/2))
