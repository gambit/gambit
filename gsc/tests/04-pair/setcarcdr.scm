(declare (extended-bindings) (not constant-fold) (not safe))

(define x (##cons 11 22))

(println (##car x))
(println (##cdr x))

(##set-car! x 33)

(println (##car x))
(println (##cdr x))

(##set-cdr! x 44)

(println (##car x))
(println (##cdr x))
