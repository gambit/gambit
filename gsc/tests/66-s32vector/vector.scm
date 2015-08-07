(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")
(define x 1.5)
(define y (##s32vector 111 -2147483648))
(define z (##list 1 2 3))

(define (test x)
  (println (##s32vector? x))
  (println (if (##s32vector? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
(test x)
(test y)
(test z)
(test (##cdr z))

