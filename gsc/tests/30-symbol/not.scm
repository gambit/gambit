(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 'symbol1)
(define v2 '(quote symbol2))

(define (test x)
  (println (if (##not x) 11 22)))

(test v1)
(test v2)
