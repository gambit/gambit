(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))

(println f)
(println t)
