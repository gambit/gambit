(include "#.scm")

(define tg (thread-thread-group (current-thread)))

(define t1 (make-thread (lambda () 123)))

(define t2 (make-thread (lambda () 123)
                        't2))

(define t3 (make-thread (lambda () 123)
                        't3
                        tg))

(check-equal? (thread-name t1) (void))
(check-equal? (thread-name t2) 't2)
(check-equal? (thread-name t3) 't3)

(check-eq? (thread-thread-group t3) tg)

(check-tail-exn type-exception? (lambda () (make-thread #f)))
(check-tail-exn type-exception? (lambda () (make-thread list #f #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-thread)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-thread list #f #f #f)))
