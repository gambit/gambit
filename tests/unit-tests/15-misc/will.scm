(include "#.scm")

(define obj (cons 1 2))
(define w (make-will obj list))

(test-assert (will? w))
(test-eq #f (will? 123))
(test-eq obj (will-testator w))
(test-eq (void) (will-execute! w))
(test-eq #f (will-testator w))

(test-error-tail type-exception? (will-testator 1))
(test-error-tail type-exception? (will-execute! 1))
(test-error-tail wrong-number-of-arguments-exception? (will?))
(test-error-tail wrong-number-of-arguments-exception? (will? 1 2))
(test-error-tail wrong-number-of-arguments-exception? (make-will))
(test-error-tail wrong-number-of-arguments-exception? (make-will obj))
(test-error-tail type-exception? (make-will obj 2))
