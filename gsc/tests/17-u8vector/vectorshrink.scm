(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u8vector 111 222))
(define v2 (##make-u8vector 10 99))

(define (test v n)
  (println (##eq? v (##u8vector-shrink! v n)))
  (println (##u8vector-length v)))

(test v1 1)
(test v2 5)
