(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define zero 0)
(define one 1)
(define ten 10)

(define (test x)
  (println (##boolean? x))
  (println (if (##boolean? x) 11 22)))

(test f)
(test t)
(test zero)
(test one)
(test ten)
