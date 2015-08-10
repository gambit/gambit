(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s8vector 127 -128))
(define v2 (##make-s8vector 10 99))

(define (test v n)
  (println (##eq? v (##s8vector-shrink! v n)))
  (println (##s8vector-length v)))

(test v1 1)
(test v2 5)
