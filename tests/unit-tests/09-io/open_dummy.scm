(include "#.scm")

(test-assert (port? (open-dummy)))
(test-error-tail wrong-number-of-arguments-exception? (open-dummy 1))
