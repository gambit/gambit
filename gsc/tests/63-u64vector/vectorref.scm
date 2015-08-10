(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u64vector 111 18446744073709551615))
(define v2 (##make-u64vector 10 99))
(define v3 '#u64(1 2 3 4))

(define (test v i expected)
  (println (##eq? (##u64vector-ref v i) expected)))

(test v1 0 111)
(test v1 1 18446744073709551615)

(test v2 9 10)

(test v3 3 4)
