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

(test-assert (eq? #f (proper-list? str)))
(test-assert (eq? #f (proper-list? int)))
(test-assert (eq? #f (proper-list? bool)))

(test-assert (eq? #t (proper-list? lst0)))
(test-assert (eq? #t (proper-list? lst1)))
(test-assert (eq? #t (proper-list? lst2)))

(test-assert (eq? #f (proper-list? lst3)))

(test-assert (eq? #f (proper-list? lst4)))
(test-assert (eq? #f (proper-list? lst5)))
(test-assert (eq? #f (proper-list? lst6)))
(test-assert (eq? #f (proper-list? lst7)))

(test-error-tail wrong-number-of-arguments-exception? (proper-list?))
(test-error-tail wrong-number-of-arguments-exception? (proper-list? bool bool))
