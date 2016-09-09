;;; SUCCEED - Test of success condition.

(define (main . args)
  (run-benchmark
   "succeed"
   1
   (lambda (result)
     (equal? result #f))
   (lambda (f) (lambda () f))
   #f))
