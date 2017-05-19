(declare (extended-bindings) (not constant-fold) (not safe))

(println (##= (##first-argument 1 1) 1))
(println (##= (##first-argument -1000 2000 3000) -1000))
(println (##= (##first-argument -1000.9293221 #t #f 10 20 30 '(1 2 3 4 5) '(2 . 45)) -1000.9293221))
(println (##eq? (##first-argument ##+ ##- ##* ##/) ##+))
(println (##= (##car (##first-argument '(1 2 3 4 5))) 1))
