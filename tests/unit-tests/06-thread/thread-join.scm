(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num) ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t1
  (make-mythread))

(define t2
  (make-thread
   (lambda ()
     (waste-time 200)
     (set! var 1)
     2)))

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-join! t1)))

(thread-start! t2)

(check-tail-exn join-timeout-exception? (lambda () (thread-join! t2 -1)))
(check-tail-exn join-timeout-exception? (lambda () (thread-join! t2 0.001)))

(check-equal? (thread-join! t2 -1 123) 123)
(check-equal? (thread-join! t2 0.001 123) 123)

(check-equal? (thread-join! t2) 2)
(check-equal? (thread-join! t2) 2)
(check-equal? (thread-join! t2 #f) 2)
(check-equal? (thread-join! t2 -1) 2)
(check-equal? (thread-join! t2 0.001) 2)
(check-equal? (thread-join! t2 -1 123) 2)
(check-equal? (thread-join! t2 0.001 123) 2)

(check-equal? var 1)

(check-tail-exn type-exception? (lambda () (thread-join! #f)))
(check-tail-exn type-exception? (lambda () (thread-join! t2 'allo)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-join!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-join! #f #f #f #f)))
