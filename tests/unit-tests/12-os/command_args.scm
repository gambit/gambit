(include "#.scm")

(test-equal '() (command-args))
(test-error-tail wrong-number-of-arguments-exception? (command-args #f))
