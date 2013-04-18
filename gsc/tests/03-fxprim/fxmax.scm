(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fxmax 11 33))
(println (##fxmax 11 -11))
(println (##fxmax 11 -33))
(println (##fxmax -11 33))
