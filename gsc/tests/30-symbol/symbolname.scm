(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (quote symbol2))
(define c (##make-uninterned-symbol "uninterned" 80))

(println (##symbol-name a))
(println (##symbol-name b))
(println (##symbol-name c))
