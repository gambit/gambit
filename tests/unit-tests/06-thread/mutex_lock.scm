(include "#.scm")

(define m1 (make-mutex))
(define m2 (make-mutex))

(test-eq 'not-abandoned (mutex-state m1))

(test-equal #t (mutex-lock! m1))

(test-eq (current-thread) (mutex-state m1))

(test-equal #f (mutex-lock! m1 0))

(test-eq 'not-abandoned (mutex-state m2))

(test-equal #t (mutex-lock! m2 #f (current-thread)))

(test-eq (current-thread) (mutex-state m2))

(test-equal #f (mutex-lock! m2 -1))
(test-equal #f (mutex-lock! m2 .01))

(test-error-tail type-exception? (mutex-lock! #f))
(test-error-tail type-exception? (mutex-lock! m1 'foo))

(test-error-tail wrong-number-of-arguments-exception? (mutex-lock!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (mutex-lock! #f #f #f #f))
