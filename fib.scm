(declare
  (standard-bindings)
  (block)
  (not interrupts-enabled)
  (fixnum)
  (not safe)
  (not inline)
)

(define (fib n)
  (if (< n 2)
    n
    (+
      (fib (- n 1))
      (fib (- n 2)))))

(fib 40)
