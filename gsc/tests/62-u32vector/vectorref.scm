(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u32vector 111 4294967295))
(define v2 (##make-u32vector 10 99))
(define v3 '#u32(1 2 3 4))

(define (test v i expected)
  (println (##eq? (##u32vector-ref v i) expected)))

(test v1 0 11)
(test v1 1 4294967295)

(test v2 9 10)

(test v3 3 4)
