(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##u16vector 111 222))
(define b (##make-u16vector 10 99))
(define c '#u16(1 2 3 4))

(define (test v)
  (println (##u16vector-length v)))

(test a)
(test b)
(test c)
