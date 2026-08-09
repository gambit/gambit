(include "#.scm")

(define m1 (make-mutex))

(define m2 (make-mutex 'm2))

(test-equal 'not-abandoned (mutex-state m1))
(test-equal 'not-abandoned (mutex-state m2))

(test-equal (void) (mutex-name m1))
(test-equal 'm2 (mutex-name m2))

(test-error-tail wrong-number-of-arguments-exception? (make-mutex #f #f))
