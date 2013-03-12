(declare (extended-bindings) (not constant-fold) (not safe))

(define a 0.0)
(define b -2.7)

(define (test x)
  (println (if x 11 22)))

(test a)
(test b)
