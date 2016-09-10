;;; FAIL - Test of failure condition.

(define (main . args)
  (run-benchmark
   "fail"
   1
   (lambda (result)
     (eq? result #t))
   (lambda (f) (lambda () f))
   #f))
