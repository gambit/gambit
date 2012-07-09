(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
)

(define x (##cons 11 22))

(println (##car x))
(println (##cdr x))
