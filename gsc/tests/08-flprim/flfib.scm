(declare (extended-bindings) (not constant-fold) (not safe))

(define (fib n)

  (define (fib n)
    (if (##fl< n 2.0)
        n
        (##fl+ (fib (##fl- n 1.0))
               (fib (##fl- n 2.0)))))

  (fib n))

(println (##fl= 6765.0 (fib 20.0)))
