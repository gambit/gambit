(include "#.scm")

(test-error-tail type-exception? (input-port-byte-position 1))
(test-error-tail type-exception? (output-port-byte-position 1))
(test-error-tail wrong-number-of-arguments-exception? (input-port-byte-position))
(test-error-tail wrong-number-of-arguments-exception? (output-port-byte-position))
