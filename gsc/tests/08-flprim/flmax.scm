(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fl=  3.5 (##flmax 1.5 3.5)))
(println (##fl=  1.5 (##flmax 1.5 -1.5)))
(println (##fl=  1.5 (##flmax 1.5 -3.5)))
(println (##fl=  3.5 (##flmax -1.5 3.5)))
