(include "#.scm")

(define m (make-mutex))

(mutex-lock! m)

(test-equal (void) (mutex-unlock! m))

(test-error-tail type-exception? (mutex-unlock! #f))
(test-error-tail type-exception? (mutex-unlock! m #f))

(test-error-tail wrong-number-of-arguments-exception? (mutex-unlock!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (mutex-unlock! #f #f #f #f))
