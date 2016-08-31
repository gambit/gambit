(declare (extended-bindings) (not constant-fold) (not safe))

(define c
  (##make-continuation (##void) 123))

(println (##continuation-frame c))
(println (##continuation-denv c))
