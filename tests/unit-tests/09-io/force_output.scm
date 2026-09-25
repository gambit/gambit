(include "#.scm")

(test-eq (void) (force-output (open-output-string)))
(test-error-tail type-exception? (force-output 1))
(test-error-tail wrong-number-of-arguments-exception? (force-output (open-output-string) 1 2))
