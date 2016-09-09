;;; FIB -- A classic benchmark, computes fib(35) inefficiently.

(define (fib n)
  (if (< n 2)
    n
    (+ (fib (- n 1))
       (fib (- n 2)))))

(define (main . args)
  (run-benchmark
    "fib"
    fib-iters
    (lambda (result) (equal? result 9227465))
    (lambda (n) (lambda () (fib n)))
    35))
