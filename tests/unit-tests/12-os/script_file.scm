(include "#.scm")

(test-equal #f (script-file))

(test-error-tail wrong-number-of-arguments-exception? (script-file #f))
