(declare (extended-bindings))

(define s1 "")
(define s2 "hello")

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x s1)
  (test2 x s2))

(test s1)
(test s2)
