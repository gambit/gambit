(declare (extended-bindings) (not constant-fold) (not safe))

(define-type pt
  id: pt
  macros:
  x
  y
)

(define a (make-pt 11 22))

(println (##structure? 0))
(println (##structure? a))

(println (##structure? (##structure-type a)))
