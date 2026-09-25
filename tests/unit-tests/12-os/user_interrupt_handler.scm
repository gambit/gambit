(include "#.scm")

(define old (current-user-interrupt-handler))
(test-assert (procedure? old))
(current-user-interrupt-handler defer-user-interrupts)
(test-eq defer-user-interrupts (current-user-interrupt-handler))
(current-user-interrupt-handler old)
(test-eq old (current-user-interrupt-handler))
(test-error-tail wrong-number-of-arguments-exception? (current-user-interrupt-handler list 1))
