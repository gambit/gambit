(declare (extended-bindings) (not constant-fold) (not safe))

(define a 0)
(define b 536870911)
(define c -536870912)

(define (test x)
  (println (##fxodd? x))
  (println (if (##fxodd? x) 11 22)))

(test a)
(test b)
(test c)
