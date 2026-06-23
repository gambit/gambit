(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))
(define lst2 (cons 1 (cons 2 (cons 3 4))))

(test-eq (cdr lst1) (last-pair lst1))
(test-eq (cddr lst2) (last-pair lst2))

(test-error-tail type-exception? (last-pair #f))

(test-error-tail wrong-number-of-arguments-exception? (last-pair))
(test-error-tail wrong-number-of-arguments-exception? (last-pair lst1 #f))

