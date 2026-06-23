(include "#.scm")

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0) (loop (- i 1) (cons i lst)) lst)))

(define (go nb-threads iterations)
  
  (define threads #f)
  
  (define (body)
    (let loop ((n 0))
      (if (< n iterations)
          
          (begin (thread-yield!) (loop (+ n 1)))
          
          n)))
  
  (set! threads (map (lambda (id) (make-thread body)) (iota nb-threads)))
  
  (map thread-start! threads)
  (map thread-join! threads))

(test-equal '(500000) (go 1 500000))

(test-equal
 '(10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000
   10000)
 (go 64 10000))

(test-error-tail wrong-number-of-arguments-exception? (thread-yield! #f))
