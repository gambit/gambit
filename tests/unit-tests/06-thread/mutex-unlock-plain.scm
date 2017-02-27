(include "#.scm")

(define m (make-mutex))

(mutex-lock! m)

(check-equal? (mutex-unlock! m) (void))

(check-tail-exn type-exception? (lambda () (mutex-unlock! #f)))
(check-tail-exn type-exception? (lambda () (mutex-unlock! m #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (mutex-unlock!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (mutex-unlock! #f #f #f #f)))
