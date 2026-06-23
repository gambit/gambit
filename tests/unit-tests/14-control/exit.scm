(include "#.scm")

(test-assert (procedure? ##exit))
;;(test-assert (procedure? ##emergency-exit))

(test-assert (procedure? exit))
(test-assert (procedure? emergency-exit))

(test-error-tail wrong-number-of-arguments-exception? (exit 1 2))
(test-error-tail wrong-number-of-arguments-exception? (emergency-exit 1 2))
