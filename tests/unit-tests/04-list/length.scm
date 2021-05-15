(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

;; proper lists
(define lst0 '())
(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

;; dotted list
(define lst3 (cons 11 (cons 22 (cons 33 44))))

(check-eqv? (length lst0) 0)
(check-eqv? (length lst1) 3)
(check-eqv? (length lst2) 4)

(check-tail-exn type-exception? (lambda () (length bool)))
(check-tail-exn type-exception? (lambda () (length lst3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (length bool bool)))
