(declare (extended-bindings) (not constant-fold) (not safe))

(define a 3.125)
(define b -1.25)

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x a)
  (test2 x b))

(test a)
(test b)
