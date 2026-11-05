(include "#.scm")

(test-assert (exact-integer? (output-port-width (current-output-port))))
(test-error-tail type-exception? (output-port-width 1))
(test-error-tail wrong-number-of-arguments-exception? (output-port-width))
(test-error-tail wrong-number-of-arguments-exception? (output-port-width (current-output-port) 1))
