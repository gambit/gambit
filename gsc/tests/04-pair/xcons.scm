(declare (extended-bindings) (not constant-fold) (not safe))

(define x (##xcons 11 22))

(println (##car x))
(println (##cdr x))
