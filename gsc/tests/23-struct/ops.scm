(declare (extended-bindings) (not constant-fold) (not safe))

(define-type pt
  id: pt
  macros:
  type-exhibitor: pt-type
  x
  y
)

(define a (make-pt 11 22))

(println (##structure? 0))
(println (##structure? a))
(println (##structure? (##structure-type a)))
(println (##eq? (pt-type) (##structure-type a)))

(println (pt? a))

(println (pt-x a))
(println (pt-y a))

(pt-x-set! a 33)

(println (pt-x a))
(println (pt-y a))

(println (##structure-length a))

(define b (##make-structure (pt-type) (##structure-length a)))

(pt-x-set! b 44)
(pt-y-set! b 55)

(println (pt-x b))
(println (pt-y b))

(println (##structure? b))
(println (##structure? (##structure-type b)))

(println (pt? b))

#|

;; needs ##string->uninterned-symbol

(define-type pt2
  macros:
  type-exhibitor: pt2-type
  x
  y
)

(define c (make-pt2 11 22))

(println (##structure? 0))
(println (##structure? c))
(println (##structure? (##structure-type c)))
(println (##eq? (pt2-type) (##structure-type c)))

(println (pt2? c))

(println (pt2-x c))
(println (pt2-y c))

(pt2-x-set! c 33)

(println (pt2-x c))
(println (pt2-y c))

|#
