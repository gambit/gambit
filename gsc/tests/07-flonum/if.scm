(declare (extended-bindings) (not constant-fold) (not safe))

(define a 3.125)
(define b -1.25)

(define (test x)
  (println (if x 11 22)))

(test a)
(test b)
