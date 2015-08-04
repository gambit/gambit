(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##u32vector 111 4294967295))
(define b (##make-u32vector 10 99))
(define c '#u32(1 2 3 4))

(define (test v)
  (println (##u32vector-length v)))

(test a)
(test b)
(test c)
