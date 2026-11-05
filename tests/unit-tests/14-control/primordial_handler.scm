(include "#.scm")

(test-assert (procedure? primordial-exception-handler))
(test-error-tail wrong-number-of-arguments-exception? (primordial-exception-handler))
(test-error-tail wrong-number-of-arguments-exception? (primordial-exception-handler 1 2))
