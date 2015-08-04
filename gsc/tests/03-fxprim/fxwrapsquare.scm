(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fxwrapsquare 0))
(println (##fxwrapsquare 11))
(println (##fxwrapsquare -11))
(println (##fxwrapsquare 23170))
(println (##fxwrapsquare -23170))
(println (##fxwrapsquare 23171))
(println (##fxwrapsquare -23171))

