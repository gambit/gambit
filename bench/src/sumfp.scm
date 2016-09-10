;;; SUMFP -- Compute sum of integers from 0 to 10000 using floating point

(define (run n)
  (let loop ((i n) (sum 0.))
    (if (FLOAT< i 0.)
      sum
      (loop (FLOAT- i 1.) (FLOAT+ i sum)))))
 
(define (main . args)
  (run-benchmark
    "sumfp"
    sumfp-iters
    (lambda (result) (equal? result 50005000.))
    (lambda (n) (lambda () (run n)))
    10000.))
