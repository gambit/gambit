(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s64vector -9223372036854775808 9223372036854775807))
(define v2 (##make-s64vector 10 99))

(define (test v i)
  (println (##eq? v (##s64vector-set! v i 88)))
  (println (##s64vector-ref v i)))

(test v1 1)
(test v2 9)
