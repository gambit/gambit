(declare (extended-bindings) (not safe))

(define a 11)
(define b 11)
(define c 22)

(define (test2 x y)
  (println (##fx= x y))
  (println (if (##fx= x y) 11 22)))

(define (test x)
  (test2 x a)
  (test2 x b)
  (test2 x c))

(test a)
(test b)
(test c)
