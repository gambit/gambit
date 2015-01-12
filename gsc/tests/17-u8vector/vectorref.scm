(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##u8vector 111 222))
(define v2 (##make-u8vector 10 99))
(define v3 '#u8(1 2 3 4))

(define (test v i)
  (println (##u8vector-ref v i)))

(test v1 0)
(test v1 1)

(test v2 9)

(test v3 3)
