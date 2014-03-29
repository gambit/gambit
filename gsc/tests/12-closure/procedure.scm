(declare (extended-bindings) (not constant-fold) (not safe))

(define f (##not 123))
(define t (##not f))
(define s "")
(define x 1.5)

(define (make-adder x)
  (lambda (y) (##fx+ x y)))

(define inc (make-adder 1))

(define (test x)
  (println (##procedure? x))
  (println (if (##procedure? x) 11 22)))

(test 0)
(test 1)
(test f)
(test t)
(test s)
(test x)
(test make-adder)
(test inc)
