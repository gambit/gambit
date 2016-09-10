;;; CRASH - Test of crash condition.

(define (main . args)
  (run-benchmark
   "crash"
   1
   (lambda (result)
     #t)
   (lambda (f) (lambda () (f)))
   #f))
