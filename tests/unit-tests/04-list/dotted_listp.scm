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

(test-assert (eq? #t (dotted-list? str)))
(test-assert (eq? #t (dotted-list? int)))
(test-assert (eq? #t (dotted-list? bool)))

(test-assert (eq? #f (dotted-list? lst0)))
(test-assert (eq? #f (dotted-list? lst1)))
(test-assert (eq? #f (dotted-list? lst2)))

(test-assert (eq? #t (dotted-list? lst3)))

(test-assert (eq? #f (dotted-list? lst4)))
(test-assert (eq? #f (dotted-list? lst5)))
(test-assert (eq? #f (dotted-list? lst6)))
(test-assert (eq? #f (dotted-list? lst7)))

(test-error-tail wrong-number-of-arguments-exception? (dotted-list?))
(test-error-tail wrong-number-of-arguments-exception? (dotted-list? bool bool))
