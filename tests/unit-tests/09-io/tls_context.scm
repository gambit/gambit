(include "#.scm")

(test-assert (foreign? (make-tls-context)))
(test-error-tail wrong-number-of-arguments-exception? (make-tls-context 1))
