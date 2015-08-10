(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s32vector -2147483648 2147483647))
(define v2 (##make-s32vector 10 99))

(define (test v n)
  (println (##eq? v (##s32vector-shrink! v n)))
  (println (##s32vector-length v)))

(test v1 1)
(test v2 5)
