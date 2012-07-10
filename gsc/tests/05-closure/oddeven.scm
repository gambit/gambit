(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
 (not interrupts-enabled)
)

(define (oddeven n)
  (define (o x) (if (fx= x 0) #f (e (fx- x n))))
  (define (e x) (if (fx= x 0) #t (o (fx- x n))))
  o)

(define odd (oddeven 1))

(println (odd 0))
(println (odd 1))
(println (odd 2))
(println (odd 3))
