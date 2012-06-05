(declare (extended-bindings))

(define f (##not 123))
(define t (##not f))

(println f)
(println t)
