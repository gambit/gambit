(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u16vector 111 222))
(define v2 (##make-u16vector 10 99))

(define (test v n)
  (println (##eq? v (##u16vector-shrink! v n)))
  (println (##u16vector-length v)))

(test v1 1)
(test v2 5)
