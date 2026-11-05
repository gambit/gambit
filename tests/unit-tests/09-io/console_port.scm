(include "#.scm")

(test-assert (port? (console-port)))
(test-assert (input-port? (console-port)))
(test-assert (output-port? (console-port)))
(test-assert (textual-port? (console-port)))

(test-error-tail wrong-number-of-arguments-exception? (console-port 1))
