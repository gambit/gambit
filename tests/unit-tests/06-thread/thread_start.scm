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
     (set! var 1))))

(check-tail-exn uninitialized-thread-exception? (lambda () (thread-start! t1)))

(thread-start! t2)

(check-tail-exn started-thread-exception? (lambda () (thread-start! t2)))

(waste-time 400)

(check-equal? var 1)

(check-tail-exn started-thread-exception? (lambda () (thread-start! t2)))

(check-tail-exn type-exception? (lambda () (thread-start! #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-start!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-start! #f #f)))
