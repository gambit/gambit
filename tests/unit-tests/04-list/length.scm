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

(test-eqv 0 (length lst0))
(test-eqv 3 (length lst1))
(test-eqv 4 (length lst2))

(test-error-tail type-exception? (length str))
(test-error-tail type-exception? (length int))
(test-error-tail type-exception? (length bool))
(test-error-tail type-exception? (length lst3))

(test-error-tail wrong-number-of-arguments-exception? (length))
(test-error-tail wrong-number-of-arguments-exception? (length bool bool))
