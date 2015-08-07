(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s8vector 127 -128))
(define v2 (##make-s8vector 10 99))
(define v3 '#s8(1 2 3 4))

(define (test v i)
  (println (##s8vector-ref v i)))

(test v1 0)
(test v1 1)
(test v2 9)
(test v3 3)
