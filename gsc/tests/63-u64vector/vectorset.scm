(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u64vector 111 18446744073709551615))
(define v2 (##make-u64vector 10 99))

(define (test v i)
  (println (##eq? v (##u64vector-set! v i 88)))
  (println (##u64vector-ref v i)))

(test v1 1)
(test v2 9)
