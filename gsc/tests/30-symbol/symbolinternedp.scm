(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (##string->symbol "symbol2"))
(define c (##make-uninterned-symbol "symbol3" 80))

(define (test x)
  (println (if (##symbol-interned? x) "interned" "uninterned")))

(test a)
(test b)
(test c)
