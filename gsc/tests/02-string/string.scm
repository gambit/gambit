(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")
(define x 1.5)
(define y (##string #\a #\b))

(define (test x)
  (println (##string? x))
  (println (if (##string? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
(test x)
(test y)
