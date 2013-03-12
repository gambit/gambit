(declare (extended-bindings) (not constant-fold) (not safe))

(define c1 #\A)
(define c2 #\B)

(define (test x)
  (println (if (##not x) 11 22)))

(test c1)
(test c2)
