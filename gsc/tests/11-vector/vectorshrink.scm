(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##vector 111 222))
(define v2 (##make-vector 10 999))

(define (test v n)
  (println (##eq? v (##vector-shrink! v n)))
  (println (##vector-length v)))

(test v1 1)
(test v2 5)
