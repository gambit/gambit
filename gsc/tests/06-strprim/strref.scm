(declare (extended-bindings) (not constant-fold) (not safe))

(define s "abcdef")

(println (##string-ref s 3))
