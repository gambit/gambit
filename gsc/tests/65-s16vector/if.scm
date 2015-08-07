(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#s16())
(define v2 '#s16(1 2 -32768))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
