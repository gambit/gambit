(declare (extended-bindings) (not constant-fold) (not safe))
(declare (inlining-limit 0) (block))

;(declare (debug))

(define (foo)
  (lambda (x) (##fx+ x x)))

(define f (foo))

(define (make-adder x)
  (lambda (y) (##fx+ y x)))

(define add1 (make-adder 1))

(println (##eq? foo (##subprocedure-parent foo)))
(println (##eq? foo (##subprocedure-parent f)))
(println (##eq? make-adder (##subprocedure-parent make-adder)))
(println (##eq? make-adder (##subprocedure-parent (##closure-code add1))))

(define (check fn)
  (let ((id (##subprocedure-id fn))
        (parent (##subprocedure-parent fn))
        (name (##subprocedure-parent-name fn)))
    (println (##subprocedure-parent-info fn))
    (println (##subprocedure-nb-closed fn))
    (println name)
    (println (##fx= 0 id))
    (println (##eq? fn
                    (##make-subprocedure
                     parent
                     id)))
    (println (##eq? fn
                    (##make-subprocedure
                     (##global-var-primitive-ref
                      (##make-global-var name))
                     id)))))

(check foo)
(check make-adder)
(check (##closure-code add1))
