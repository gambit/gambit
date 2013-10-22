(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##vector 111 222))
(define b (##make-vector 10 999))
(define c '#(1 2 3 4))

(define (test v)
  (println (##vector-length v)))

(test a)
(test b)
(test c)
