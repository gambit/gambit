(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##ratnum-make 11 3))
(define b (##ratnum-make 2 3))

(define (test x)
  (println (##ratnum-denominator x)))

(test a)
(test b)

