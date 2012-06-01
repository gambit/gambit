(declare
 (standard-bindings)
 (fixnum)
 (not safe))
; (not interrupts-enabled))

(define (fib n)
  (if (fx< n 2)
      n
      (fx+ (fib (fx- n 2))
         (fib (fx- n 1)))))

(print (fib 11))
