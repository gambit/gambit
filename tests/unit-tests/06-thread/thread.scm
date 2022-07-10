(include "#.scm")

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num) ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t
  (thread
   (lambda ()
     (set! var 1))))

(waste-time 400)

(check-equal? var 1)

(check-tail-exn type-exception? (lambda () (thread #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread list #f)))
