(declare (extended-bindings) (not constant-fold) (not safe))

(define c1 #\A)
(define c2 #\B)

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x c1)
  (test2 x c2))

(test c1)
(test c2)
