(include "#.scm")

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num) ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t
  (make-thread
   (lambda ()
     (waste-time 200)
     (set! var 1)
     2)))

(thread-start! t)

(check-tail-exn join-timeout-exception? (lambda () (thread-join! t -1)))
(check-tail-exn join-timeout-exception? (lambda () (thread-join! t 0.001)))

(check-equal? (thread-join! t -1 123) 123)
(check-equal? (thread-join! t 0.001 123) 123)

(check-equal? (thread-join! t) 2)
(check-equal? (thread-join! t) 2)
(check-equal? (thread-join! t #f) 2)
(check-equal? (thread-join! t -1) 2)
(check-equal? (thread-join! t 0.001) 2)
(check-equal? (thread-join! t -1 123) 2)
(check-equal? (thread-join! t 0.001 123) 2)

(check-equal? var 1)

(check-tail-exn type-exception? (lambda () (thread-join! #f)))
(check-tail-exn type-exception? (lambda () (thread-join! t 'allo)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-join!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-join! #f #f #f #f)))
