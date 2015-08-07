(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s64vector -9223372036854775808 9223372036854775807))
(define v2 (##make-s64vector 10 99))

(define (test v n)
  (println (##eq? v (##s64vector-shrink! v n)))
  (println (##s64vector-length v)))

(test v1 1)
(test v2 5)
