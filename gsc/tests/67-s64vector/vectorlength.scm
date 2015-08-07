(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##s64vector -9223372036854775808 9223372036854775807))
(define b (##make-s64vector 10 99))
(define c '#s64(1 2 3 4))

(define (test v)
  (println (##s64vector-length v)))

(test a)
(test b)
(test c)
