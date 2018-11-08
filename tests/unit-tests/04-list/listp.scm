(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-false (list? str))
(check-false (list? int))
(check-false (list? bool))

(check-true (list? lst1))
(check-true (list? lst2))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list? bool bool)))
