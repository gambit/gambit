(include "#.scm")

(test-equal #f (command-name))

(test-error-tail wrong-number-of-arguments-exception? (command-name #f))
