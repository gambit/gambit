(include "#.scm")

(define m1 (make-mutex))

(define m2 (make-mutex 'm2))

(check-equal? (mutex-state m1) 'not-abandoned)
(check-equal? (mutex-state m2) 'not-abandoned)

(check-equal? (mutex-name m1) (void))
(check-equal? (mutex-name m2) 'm2)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-mutex #f #f)))
