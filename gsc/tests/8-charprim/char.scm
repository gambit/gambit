(declare (extended-bindings))

(define f (##not 123))
(define t (##not f))
(define c #\A)

(define (test x)
  (println (##char? x))
  (println (if (##char? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test c)
