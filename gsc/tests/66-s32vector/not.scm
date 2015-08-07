(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#s32())
(define v2 '#s32(1 2 -2147483648))

(define (test x)
  (println (if (##not x) 11 22)))

(test v1)
(test v2)
