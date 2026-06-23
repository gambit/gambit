(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))
(define lst2 (cons 1 (cons 2 (cons 3 4))))

(test-equal 2 (last lst1))
(test-equal 3 (last lst2))

(test-error-tail type-exception? (last #f))

(test-error-tail wrong-number-of-arguments-exception? (last))
(test-error-tail wrong-number-of-arguments-exception? (last lst1 #f))

