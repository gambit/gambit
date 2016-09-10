;;; TFIB -- Like FIB but using threads.

(define (tfib n)
  (if (< n 2)
      1
      (let ((x (make-thread (lambda () (tfib (- n 2))))))
        (thread-start! x)
        (let ((y (tfib (- n 1))))
          (+ (thread-join! x) y)))))

(define (go n repeat)
  (let loop ((repeat repeat)
             (result '()))
    (if (> repeat 0)
        (let ((x (make-thread (lambda () (tfib n)))))
          (thread-start! x)
          (let ((r (thread-join! x)))
            (loop (- repeat 1) r)))
        result)))

(define (main . args)
  (run-benchmark
   "tfib"
   tfib-iters
   (lambda (result) (equal? result 610))
   (lambda (n repeat) (lambda () (go n repeat)))
   14
   100))
