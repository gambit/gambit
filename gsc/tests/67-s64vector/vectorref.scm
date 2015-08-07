(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##s64vector -9223372036854775808 9223372036854775807))
(define v2 (##make-s64vector 10 99))
(define v3 '#s64(1 2 3 4))

(define (test v i expected)
  (println (##eq? (##s64vector-ref v i) expected)))

(test v1 0 -9223372036854775808)
(test v1 1 9223372036854775807)

(test v2 9 99)

(test v3 3 4)
