(declare (extended-bindings) (not constant-fold) (not safe))

(println (##fxsquare? 0))
(println (##fxsquare? 11))
(println (##fxsquare? -11))
(println (##fxsquare? 23170))
(println (##fxsquare? -23170))
(println (##fxsquare? 23171))
(println (##fxsquare? -23171))
(println (##fxsquare? 23172))
(println (##fxsquare? -23172))

