(include "#.scm")

(test-assert (input-port? (repl-input-port)))
(test-assert (output-port? (repl-output-port)))
(test-assert (output-port? (repl-error-port)))

(test-error-tail wrong-number-of-arguments-exception? (repl-input-port 1))
(test-error-tail wrong-number-of-arguments-exception? (repl-output-port 1))
(test-error-tail wrong-number-of-arguments-exception? (repl-error-port 1))
