(include "#.scm")

(test-eq (void) (defer-user-interrupts))
(test-error-tail wrong-number-of-arguments-exception? (defer-user-interrupts 1))
