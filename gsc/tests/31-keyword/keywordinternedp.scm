(declare (extended-bindings) (not constant-fold) (not safe))

(define a keyword1:)
(define b keyword2:)
(define c (##make-uninterned-keyword "uninterned" 80))

(println (if (##boolean? (##keyword-interned? a)) "boolean" "not boolean"))
(println (if (##keyword-interned? a) "interned" "uninterned"))

(println (if (##boolean? (##keyword-interned? b)) "boolean" "not boolean"))
(println (if (##keyword-interned? b) "interned" "uninterned"))

(println (if (##boolean? (##keyword-interned? c)) "boolean" "not boolean"))
(println (if (##keyword-interned? c) "interned" "uninterned"))
