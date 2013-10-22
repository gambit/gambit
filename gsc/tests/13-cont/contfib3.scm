(declare (extended-bindings) (not constant-fold) (not safe))

(define (my-call/cc receiver)
  (##continuation-capture
   (lambda (k)
     (receiver (lambda (r)
                 (##continuation-return-no-winding k r))))))

(define (fib n)

  (define (fib n)
    (if (##fx< n 2)

        (my-call/cc
         (lambda (k)
           (k 1)))

        (##fx+ (fib (##fx- n 1))
               (fib (##fx- n 2)))))

  (fib n))

(println (fib 25))
