(declare (extended-bindings) (not constant-fold) (not safe))

(define a 0.0)
(define b 1.5)
(define c -1.5)

(define (test x)
  (println (##flpositive? x))
  (println (if (##flpositive? x) 11 22)))

(test a)
(test b)
(test c)
(test -0.0)
