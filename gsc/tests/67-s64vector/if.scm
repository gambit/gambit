(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#s64())
(define v2 '#s64(1 2 -9223372036854775808))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
