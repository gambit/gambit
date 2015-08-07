(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#f32())
(define v2 '#f32(1.5 2.5 3.5))

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x v1)
  (test2 x v2))

(test v1)
(test v2)
