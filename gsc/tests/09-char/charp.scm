(declare (extended-bindings) (not constant-fold) (not safe))

(define c1 #\A)
(define notchar 42)

(define (test x)
  (println (##char? x)))

(test c1)
(test notchar)
