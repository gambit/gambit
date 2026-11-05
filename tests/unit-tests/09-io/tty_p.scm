(include "#.scm")

(test-assert (tty? (console-port)))
(test-eq #f (tty? (open-output-string)))
(test-error-tail wrong-number-of-arguments-exception? (tty?))
(test-error-tail wrong-number-of-arguments-exception? (tty? 1 2))
