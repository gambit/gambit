;;; Compute fib using threads.

;;; Compute fib using threads.

(declare (standard-bindings) (block))

(define (busy-sleep n)
  (if (> n 0)
      (busy-sleep (- n 1))
      #f))

(define (short-delay)
  (busy-sleep 6000)) ;; about 5 us

(define (tfib n)
  (short-delay)
  (if (< n 2)
      1
      (let* ((x (thread-start! (make-thread (lambda () (tfib (- n 2))))))
             (y (tfib (- n 1))))
          (+ (thread-join! x) y))))

(define (range i j)
  (let loop ((j (- j 1)) (lst '()))
    (if (< j i)
        lst
        (loop (- j 1) (cons j lst)))))

(define (go n repeat)
  (let ((threads
         (map (lambda (i) (make-thread (lambda () (tfib n))))
              (range 0 repeat))))
    (for-each thread-start! threads)
    (map thread-join! threads)))

(go 15 5000)
