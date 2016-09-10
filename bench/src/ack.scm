;;; ACK -- One of the Kernighan and Van Wyk benchmarks.

(define (ack m n)
  (cond ((= m 0) (+ n 1))
        ((= n 0) (ack (- m 1) 1))
        (else (ack (- m 1) (ack m (- n 1))))))

(define (main . args)
  (run-benchmark
    "ack"
    ack-iters
    (lambda (result) (equal? result 4093))
    (lambda (m n) (lambda () (ack m n)))
    3
    9))
