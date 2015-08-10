(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u64vector 111 18446744073709551615))
(define v2 (##make-u64vector 10 99))

(define (test v n)
  (println (##eq? v (##u64vector-shrink! v n)))
  (println (##u64vector-length v)))

(test v1 1)
(test v2 5)
