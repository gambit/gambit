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

(test-eqv 0 (length+ lst0))
(test-eqv 3 (length+ lst1))
(test-eqv 4 (length+ lst2))

(test-eqv #f (length+ lst4))
(test-eqv #f (length+ lst5))
(test-eqv #f (length+ lst6))
(test-eqv #f (length+ lst7))

(test-error-tail type-exception? (length+ str))
(test-error-tail type-exception? (length+ int))
(test-error-tail type-exception? (length+ bool))
(test-error-tail type-exception? (length+ lst3))

(test-error-tail wrong-number-of-arguments-exception? (length+))
(test-error-tail wrong-number-of-arguments-exception? (length+ bool bool))
