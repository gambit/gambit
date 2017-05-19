(declare (extended-bindings) (not constant-fold) (not safe))

(define (sum . lst)
  (let loop ((lst lst) (result 0))
    (if (##null? lst)
        result
        (loop (##cdr lst)
              (##fx+ (##car lst) result)))))

(define (func-fx= x y)
  (##fx= x y))

(println (##apply func-fx= '(1 1)))
(println (##apply func-fx= '(1 2)))

(println (##apply sum '()))
(println (##apply sum '(1)))
(println (##apply sum '(1 2)))
(println (##apply sum '(1 2 3)))
(println (##apply sum '(1 2 3 4)))
(println (##apply sum '(1 2 3 4 5)))
(println (##apply sum '(1 2 3 4 5 6)))
(println (##apply sum '(1 2 3 4 5 6 7)))
(println (##apply sum '(1 2 3 4 5 6 7 8)))
(println (##apply sum '(1 2 3 4 5 6 7 8 9)))
(println (##apply sum '(1 2 3 4 5 6 7 8 9 10)))

(println (##apply sum '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)))
