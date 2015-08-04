(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##f32vector 1.5 2.5))
(define v2 (##make-f32vector 10 5.5))

(define (test v n)
  (println (##eq? v (##f32vector-shrink! v n)))
  (println (##f32vector-length v)))

(test v1 1)
(test v2 5)
