(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##vector 111 222))
(define v2 (##make-vector 10 999))

(define (test v i)
  (println (##vector-ref v i))
  (println (##eq? v (##vector-set! v i 888)))
  (println (##vector-ref v i)))

(test v1 1)
(test v2 9)
