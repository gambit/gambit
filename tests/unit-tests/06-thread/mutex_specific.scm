(include "#.scm")

(define m1 (make-mutex))
(define m2 (make-mutex 'm2))

(test-equal (void) (mutex-specific m1))
(test-equal (void) (mutex-specific m2))

(test-equal (void) (mutex-specific-set! m1 'payload))
(test-eq 'payload (mutex-specific m1))
(test-equal (void) (mutex-specific m2))

(mutex-specific-set! m1 0)
(test-equal 0 (mutex-specific m1))

(test-error-tail type-exception? (mutex-specific #f))
(test-error-tail type-exception? (mutex-specific-set! #f 'x))
(test-error-tail wrong-number-of-arguments-exception? (mutex-specific))
(test-error-tail wrong-number-of-arguments-exception? (mutex-specific-set! m1))
