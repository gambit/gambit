(declare (extended-bindings) (not constant-fold) (not safe))

(define s (##make-string 5 #\!))

(println (##eq? s (##string-set! s 3 #\x)))

(println s)
