(declare (extended-bindings))

(define f (##not 123))
(define t (##not f))

(define (test x)
  (println (if x 11 22)))

(test f)
(test t)
