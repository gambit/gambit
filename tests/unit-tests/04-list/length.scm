(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-eqv? (length lst1) 3)
(check-eqv? (length lst2) 4)

(check-tail-exn type-exception? (lambda () (length bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length bool bool)))
