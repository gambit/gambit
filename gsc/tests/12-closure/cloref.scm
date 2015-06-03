(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo a b c)
  (lambda (x) (##fx+ x (##fx+ a (##fx+ b c)))))

(define c1 (make-clo 11 22 33))
(define c2 (make-clo 44 55 66))

(println (##closure-ref c1 1))
(println (##closure-ref c1 2))
(println (##closure-ref c1 3))

(println (##closure-ref c2 1))
(println (##closure-ref c2 2))
(println (##closure-ref c2 3))
