(declare (extended-bindings) (not constant-fold) (not safe))

(println (##apply eq? '(1 1)))
(println (##apply eq? '(1 2)))

(println (##apply + '(1)))
(println (##apply * '(1 2)))
(println (##apply - '(1 2 3)))
(println (##apply + '(1 2 3 4)))
(println (##apply * '(1 2 3 4 5)))
(println (##apply - '(1 2 3 4 5 6)))
(println (##apply + '(1 2 3 4 5 6 7)))
(println (##apply * '(1 2 3 4 5 6 7 8)))
(println (##apply - '(1 2 3 4 5 6 7 8 9)))
(println (##apply + '(1 2 3 4 5 6 7 8 9 10)))

(println (##apply + '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)))
