(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
)

(define c 0)

(define (fib n)
  (if (##fx< n 2)

#;
      (##continuation-capture
       (lambda (k)
         (##continuation-return k 1)))

      (begin
        (set! c (##fx+ c 1))
        (if (##fx= c 10)
            (##continuation-capture
             (lambda (k)
               (set! c 0)
               (##continuation-graft k (lambda () 1))))
            1))

      (##fx+ (fib (##fx- n 1))
             (fib (##fx- n 2)))))

(println (fib 20))
