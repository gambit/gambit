(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
)

(define (oddeven n)
  (define (o x) (if (fx= x 0) #f (e (fx- x n))))
  (define (e x) (if (fx= x 0) #t (o (fx- x n))))
  (cons o e))

(define odd (car (oddeven 1)))

(println (odd 0))
(println (odd 1))
(println (odd 2))
(println (odd 3))
