(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")
(define x 1.5)

(define (test x)
  (println (##flonum? x))
  (println (if (##flonum? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
(test x)
