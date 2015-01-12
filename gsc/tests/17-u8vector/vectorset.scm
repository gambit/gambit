(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u8vector 111 222))
(define v2 (##make-u8vector 10 99))

(define (test v i)
  (println (##u8vector-ref v i))
  (println (##eq? v (##u8vector-set! v i 88)))
  (println (##u8vector-ref v i)))

(test v1 1)
(test v2 9)
