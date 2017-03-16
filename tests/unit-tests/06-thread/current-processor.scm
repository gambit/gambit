(include "#.scm")

(check-true (processor? (current-processor)))

(check-eq? (current-processor) (current-processor))

(check-true (fixnum? (processor-id (current-processor))))

(check-tail-exn type-exception? (lambda () (processor-id #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (current-processor #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (processor-id)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (processor-id #f #f)))
