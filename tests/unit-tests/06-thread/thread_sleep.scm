(include "#.scm")

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0) (loop (- i 1) (cons i lst)) lst)))

(define (go nb-threads iterations timeout)
  
  (define threads #f)
  
  (define (body)
    (let loop ((n 0))
      (if (< n iterations)
          
          (begin (thread-sleep! timeout) (loop (+ n 1)))
          
          n)))
  
  (set! threads (map (lambda (id) (make-thread body)) (iota nb-threads)))
  
  (map thread-start! threads)
  (map thread-join! threads))

(test-equal '(100) (go 1 100 .001))

(test-equal
 '(10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10
   10)
 (go 64 10 .001))

(test-equal '(1000) (go 1 1000 -1))

(test-equal
 '(1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000
   1000)
 (go 64 1000 -1))

(test-equal
 '(10000)
 (go 1 10000 (seconds->time (+ (time->seconds (current-time)) .001))))

(test-error-tail type-exception? (thread-sleep! #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-sleep!))
(test-error-tail wrong-number-of-arguments-exception? (thread-sleep! 0 0))
