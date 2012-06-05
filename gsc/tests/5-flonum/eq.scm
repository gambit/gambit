(declare (extended-bindings))

(define a 0.0)
(define b -2.7)

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x a)
  (test2 x b))

(test a)
(test b)
