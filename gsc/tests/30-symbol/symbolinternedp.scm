(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (quote symbol2))
(define c (##make-uninterned-symbol "uninterned" 80))

(println (if (##boolean? (##symbol-interned? a)) "boolean" "not boolean"))
(println (if (##symbol-interned? a) "interned" "uninterned"))

(println (if (##boolean? (##symbol-interned? b)) "boolean" "not boolean"))
(println (if (##symbol-interned? b) "interned" "uninterned"))

(println (if (##boolean? (##symbol-interned? c)) "boolean" "not boolean"))
(println (if (##symbol-interned? c) "interned" "uninterned"))
