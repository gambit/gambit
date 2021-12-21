(declare (extended-bindings) (not constant-fold) (not safe))

(define k1 'hello:)
(define k2 '||:)
(define k3 '|a b c|:)

(define (test x)
  (let ((s (##keyword->string? x)))
    (println s)
    (println (##string? s))))

(test k1)
(test k2)
(test k3)
