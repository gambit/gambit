(declare (extended-bindings) (not safe))

(println (##fxwrap+ 11 33))
(println (##fxwrap+ 11 -11))
(println (##fxwrap+ 11 -33))
(println (##fxwrap+ -11 33))
