(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fxmin 11 33))
(println (##fxmin 11 -11))
(println (##fxmin 11 -33))
(println (##fxmin -11 33))
