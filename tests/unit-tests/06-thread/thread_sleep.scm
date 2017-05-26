(include "#.scm")

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0)
        (loop (- i 1) (cons i lst))
        lst)))

(define (go nb-threads iterations timeout)

  (define threads #f)

  (define (body)
    (let loop ((n 0))
      (if (< n iterations)

          (begin
            (thread-sleep! timeout)
            (loop (+ n 1)))

          n)))

  (set! threads
        (map (lambda (id) (make-thread body))
             (iota nb-threads)))

  (map thread-start! threads)
  (map thread-join! threads))

(check-equal? (go 1 100 0.001)
              '(100))

(check-equal? (go 64 10 0.001)
              '(10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10))

(check-equal? (go 1 1000 -1)
              '(1000))

(check-equal? (go 64 1000 -1)
              '(1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000))

(check-equal? (go 1 10000 (seconds->time (+ (time->seconds (current-time)) 0.001)))
              '(10000))

(check-tail-exn type-exception? (lambda () (thread-sleep! #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-sleep!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-sleep! 0 0)))
