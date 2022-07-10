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

;; circular-lists
(define lst4 (list 11))
(set-cdr! lst4 lst4)
(define lst5 (list 11 22))
(set-cdr! (cdr lst5) lst5)
(define lst6 (list 11 22 33))
(set-cdr! (cddr lst6) lst6)
(define lst7 (list 11 22 33))
(set-cdr! (cddr lst7) (cdr lst7))

(check-false (list? str))
(check-false (list? int))
(check-false (list? bool))

(check-true  (list? lst0))
(check-true  (list? lst1))
(check-true  (list? lst2))

(check-false (list? lst3))

(check-false (list? lst4))
(check-false (list? lst5))
(check-false (list? lst6))
(check-false (list? lst7))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list? bool bool)))
