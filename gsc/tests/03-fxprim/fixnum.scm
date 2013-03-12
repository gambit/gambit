(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")

(define (test x)
  (println (##fixnum? x))
  (println (if (##fixnum? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
