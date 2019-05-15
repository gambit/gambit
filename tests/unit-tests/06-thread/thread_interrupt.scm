(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num) ;; waste some time
        (waste-time (- n 1)))))

(define var #f)

(define t1
  (make-mythread))

(define t2
  (make-thread
   (lambda ()
     (parameterize ((current-user-interrupt-handler
                     (lambda () (set! var (+ var 1)) 123)))
       (set! var 0)
       (waste-time 100)
       (set! var (+ var 10))))))

(check-tail-exn inactive-thread-exception? (lambda () (thread-interrupt! t1)))

(check-tail-exn inactive-thread-exception? (lambda () (thread-interrupt! t2)))

(thread-start! t2)

(let loop ()
  (or var (loop)))

(check-eq? (thread-interrupt! t2 current-thread) t2)
(check-equal? (thread-interrupt! t2) 123)

(waste-time 200)

(check-equal? var 11)

(check-tail-exn type-exception? (lambda () (thread-interrupt! #f)))
(check-tail-exn type-exception? (lambda () (thread-interrupt! #f list)))
(check-tail-exn type-exception? (lambda () (thread-interrupt! t1 #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-interrupt!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-interrupt! t1 list #f)))
