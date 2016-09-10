;;; SUM1 -- One of the Kernighan and Van Wyk benchmarks.

(define inport #f)

(define (sumport port sum-so-far)
  (let ((x (read port)))
    (if (eof-object? x)
        sum-so-far
        (sumport port (FLOAT+ x sum-so-far)))))

(define (sum port)
  (sumport port 0.0))

(define (go)
  (set! inport (open-input-file "../../src/rn100"))
  (let ((result (sum inport)))
    (close-input-port inport)
    result))

(define (main . args)
  (run-benchmark
   "sum1"
   sum1-iters
   (lambda (result) (and (FLOAT>= result 15794.974999999)
                         (FLOAT<= result 15794.975000001)))
   (lambda () (lambda () (go)))))
