(include "#.scm")

(test-equal #f (script-directory))

(test-error-tail wrong-number-of-arguments-exception? (script-directory #f))
