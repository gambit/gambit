(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (quote symbol2))
(define c (##make-uninterned-symbol "uninterned" 80))

(println (##symbol? a))
(println (##symbol? b))
(println (##symbol? c))
