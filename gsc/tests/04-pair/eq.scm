(declare (extended-bindings))

(define l1 '())
(define l2 '(1 2 3))

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x l1)
  (test2 x l2))

(test l1)
(test l2)
