(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
)

(define (fib n)

  (define (fib n)
    (if (##fx< n 2)

        (##continuation-capture
         (lambda (k)
           (##continuation-graft-no-winding k (lambda () 1))))

        (##fx+ (fib (##fx- n 1))
               (fib (##fx- n 2)))))

  (fib n))

(println (fib 20))
