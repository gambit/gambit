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
     (set! var 1))))

(thread-start! t)

(check-tail-exn started-thread-exception? (lambda () (thread-start! t)))

(waste-time 400)

(check-equal? var 1)

(check-tail-exn type-exception? (lambda () (thread-start! #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-start!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-start! #f #f)))
