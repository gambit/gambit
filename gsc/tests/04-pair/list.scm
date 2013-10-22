(declare (extended-bindings) (not constant-fold) (not safe))

(define x (##list 11 22 33))
(define y (##list))
(define z '())

(println x)
(println (##car x))
(println (##cdr x))

(println (##null? x))
(println (if (##null? x) 11 22))
(println (##null? y))
(println (if (##null? z) 11 22))
(println (##null? z))
(println (if (##null? z) 11 22))
(println (##null? (##cdr (##cdr (##cdr x)))))
(println (if (##null? (##cdr (##cdr (##cdr x)))) 11 22))
