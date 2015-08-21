(declare (extended-bindings) (not constant-fold) (not safe))

(define a 'keyword1:)
(define b (##string->keyword "keyword2"))
(define c (##make-uninterned-keyword "keyword3" 80))

(define (test x)
  (println (if (##keyword-interned? x) "interned" "uninterned")))

(test a)
(test b)
(test c)
