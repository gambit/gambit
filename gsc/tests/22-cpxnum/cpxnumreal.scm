(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##cpxnum-make 11 3))

(define (test x)
  (println (##cpxnum-real x)))

(test a)

