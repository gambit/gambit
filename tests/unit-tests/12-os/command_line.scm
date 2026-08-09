(include "#.scm")

(test-equal '("") (command-line))

(test-error-tail wrong-number-of-arguments-exception? (command-line #f))
