(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#s8())
(define v2 '#s8(1 2 -128))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
