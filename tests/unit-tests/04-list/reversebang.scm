(include "#.scm")

(define lst1 (list 1 2 3 4))
(define lst2 (reverse! lst1))

(test-equal '(1) lst1)
(test-equal '(4 3 2 1) lst2)

(test-equal '() (reverse! '()))

(test-error-tail type-exception? (reverse! #f))

(test-error-tail wrong-number-of-arguments-exception? (reverse!))
(test-error-tail wrong-number-of-arguments-exception? (reverse! lst1 #f))

