(declare (extended-bindings))

(define a 0.0)
(define b -2.7)

(define (test x)
  (println (if (##not x) 11 22)))

(test a)
(test b)
