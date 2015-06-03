(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo-add a)
  (lambda (x) (##fx+ x a)))

(define c (make-clo-add 1))

(println (##closure? make-clo-add))
(println (##closure? c))
