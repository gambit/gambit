(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u32vector 111 4294967295))
(define v2 (##make-u32vector 10 99))

(define (test v n)
  (println (##eq? v (##u32vector-shrink! v n)))
  (println (##u32vector-length v)))

(test v1 1)
(test v2 5)
