(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-eqv 11 (list-ref lst1 0))
(test-eqv 22 (list-ref lst1 1))
(test-eqv 33 (list-ref lst1 2))

(test-eqv 11 (list-ref lst2 0))
(test-eqv 22 (list-ref lst2 1))
(test-eqv 33 (list-ref lst2 2))
(test-eqv 44 (list-ref lst2 3))

(test-error-tail type-exception? (list-ref bool 0))
(test-error-tail type-exception? (list-ref lst1 bool))
(test-error-tail range-exception? (list-ref lst1 -1))
(test-error-tail type-exception? (list-ref lst1 3))

(test-error-tail wrong-number-of-arguments-exception? (list-ref))
(test-error-tail wrong-number-of-arguments-exception? (list-ref lst1))
(test-error-tail wrong-number-of-arguments-exception? (list-ref lst1 0 0))
