(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-eqv? (list-ref lst1 0) 11)
(check-eqv? (list-ref lst1 1) 22)
(check-eqv? (list-ref lst1 2) 33)

(check-eqv? (list-ref lst2 0) 11)
(check-eqv? (list-ref lst2 1) 22)
(check-eqv? (list-ref lst2 2) 33)
(check-eqv? (list-ref lst2 3) 44)

(check-tail-exn type-exception? (lambda () (list-ref bool 0)))
(check-tail-exn type-exception? (lambda () (list-ref lst1 bool)))
(check-tail-exn range-exception? (lambda () (list-ref lst1 -1)))
(check-tail-exn range-exception? (lambda () (list-ref lst1 3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-ref lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-ref lst1 0 0)))
