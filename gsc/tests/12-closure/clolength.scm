(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo a b c)
  (lambda (x) (##fx+ x (##fx+ a (##fx+ b c)))))

(define c1 (make-clo 11 22 33))
(define c2 (make-clo 44 55 66))

(println (##closure-length c1))
(println (##closure-length c2))
