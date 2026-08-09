(include "#.scm")

(test-assert (eq? #t (processor? (current-processor))))

(test-eq (current-processor) (current-processor))

(test-assert (eq? #t (fixnum? (processor-id (current-processor)))))

(test-error-tail type-exception? (processor-id #f))

(test-error-tail wrong-number-of-arguments-exception? (current-processor #f))

(test-error-tail wrong-number-of-arguments-exception? (processor-id))
(test-error-tail wrong-number-of-arguments-exception? (processor-id #f #f))
