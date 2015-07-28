(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'symbol1)
(define b (quote symbol2))
(define c (##make-uninterned-symbol "uninterned" 80))

(define (test x name)
  (println (##symbol-name x))
  (##symbol-name-set! x name)
  (println (##symbol-name x)))

(test a "symbola")
(test b "symbolb")
(test c "symbolc")
