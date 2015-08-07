(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s16vector 32767 -32768))
(define v2 (##make-s16vector 10 99))

(define (test v n)
  (println (##eq? v (##s16vector-shrink! v n)))
  (println (##s16vector-length v)))

(test v1 1)
(test v2 5)
