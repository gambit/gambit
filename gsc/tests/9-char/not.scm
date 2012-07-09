(declare (extended-bindings))

(define c1 #\A)
(define c2 #\B)

(define (test x)
  (println (if (##not x) 11 22)))

(test c1)
(test c2)
