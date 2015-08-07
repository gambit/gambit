(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##s32vector -2147483648 2147483647))
(define b (##make-s32vector 10 99))
(define c '#s32(1 2 3 4))

(define (test v)
  (println (##s32vector-length v)))

(test a)
(test b)
(test c)
