(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##s8vector 111 -22))
(define b (##make-s8vector 10 99))
(define c '#s8(1 2 127 4))

(define (test v)
  (println (##s8vector-length v)))

(test a)
(test b)
(test c)
