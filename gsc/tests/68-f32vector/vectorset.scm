(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##f32vector 1.5 2.5))
(define v2 (##make-f32vector 10 5.5))

(define (test v i)
  (println (##f32vector-ref v i))
  (println (##eq? v (##f32vector-set! v i 9.5)))
  (println (##f32vector-ref v i)))

(test v1 1)
(test v2 9)
