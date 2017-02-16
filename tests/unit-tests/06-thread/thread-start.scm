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

(waste-time 400)

(check-equal? var 1)
