;;; FIBFP -- Computes fib(35) using floating point

(define (fibfp n)
  (if (FLOAT< n 2.)
    n
    (FLOAT+ (fibfp (FLOAT- n 1.))
            (fibfp (FLOAT- n 2.)))))

(define (main . args)
  (run-benchmark
    "fibfp"
    fibfp-iters
    (lambda (result) (equal? result 9227465.))
    (lambda (n) (lambda () (fibfp n)))
    35.))
