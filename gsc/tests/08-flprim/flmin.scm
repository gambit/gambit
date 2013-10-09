(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fl=  1.5 (##flmin 1.5 3.5)))
(println (##fl= -1.5 (##flmin 1.5 -1.5)))
(println (##fl= -3.5 (##flmin 1.5 -3.5)))
(println (##fl= -1.5 (##flmin -1.5 3.5)))
