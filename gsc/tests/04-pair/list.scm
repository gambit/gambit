(declare
 (standard-bindings)
 (extended-bindings)
 (not safe))

(define x (##list 11 22 33))

(println x)
(println (##car x))
(println (##cdr x))
