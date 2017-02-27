(include "#.scm")

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0)
        (loop (- i 1) (cons i lst))
        lst)))

(define iterations 2000)
(define nb-competing-threads 20)
(define nb-independent-threads 20)

(define (go)

  (define threads #f)

  (define count 0)

  (define mut (make-mutex))

  (define (body)
    (let loop ((n iterations))
      (if (> n 0)
          (begin

            (mutex-lock! mut)
            (set! count (+ count 1))
            (mutex-unlock! mut)

            (loop (- n 1))))))

  (set! threads
        (map (lambda (id) (make-thread body))
             (iota nb-competing-threads)))

  (map thread-start! threads)
  (map thread-join! threads)

  count)

(define result
  (map thread-join!
       (map (lambda (id) (thread-start! (make-thread go)))
            (iota nb-independent-threads))))

(check-equal? result
              '(40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000 40000))
