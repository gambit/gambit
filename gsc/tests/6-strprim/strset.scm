(declare (extended-bindings) (not safe))

(define s (##make-string 5 #\!))

(##string-set! s 3 #\x)

(println s)
