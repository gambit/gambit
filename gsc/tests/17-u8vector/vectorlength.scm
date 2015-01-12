(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##u8vector 111 222))
(define b (##make-u8vector 10 99))
(define c '#u8(1 2 3 4))

(define (test v)
  (println (##u8vector-length v)))

(test a)
(test b)
(test c)
