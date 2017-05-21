(declare (extended-bindings) (not constant-fold) (not safe))

(println (##first-argument 42))
(println (##first-argument 1 2))
(println (##first-argument -1000 2000 3000))
(println (##first-argument -1.5 #t #f 10 20 30 '(1 2 3 4 5) '(2 . 45)))
(println (##car (##first-argument '(1 2 3 4 5) "second")))
(println (##eq? (##first-argument println 1 2 3 4) println))
