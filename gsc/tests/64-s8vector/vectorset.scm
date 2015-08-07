(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s8vector 127 -128))
(define v2 (##make-s8vector 10 99))

(define (test v i)
  (println (##s8vector-ref v i))
  (println (##eq? v (##s8vector-set! v i 88)))
  (println (##s8vector-ref v i)))

(test v1 1)
(test v2 9)
