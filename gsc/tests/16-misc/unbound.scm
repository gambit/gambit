(declare (extended-bindings) (not constant-fold) (not safe))

(println (##unbound? (##global-var-ref (##make-global-var 'unknown))))
(println (##unbound? 0))
(println (##unbound? #f))
(println (##unbound? #t))
(println (##unbound? 'sym))
(println (##unbound? '()))
