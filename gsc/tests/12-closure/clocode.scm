(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo-add a b c)
  (lambda (x) (##fx+ x (##fx+ a (##fx+ b c)))))

(define (make-clo-mul a b c)
  (lambda (x y) (##fx* (##fx* x y) (##fx* a (##fx* b c)))))

(define c1 (make-clo-add 11 22 33))
(define c2 (make-clo-add 44 55 66))
(define c3 (make-clo-mul 77 88 99))

(println (##eq? (##closure-code c1) (##closure-code c2)))
(println (##eq? (##closure-code c1) (##closure-code c3)))
