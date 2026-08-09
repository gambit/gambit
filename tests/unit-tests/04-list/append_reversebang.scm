(include "#.scm")

(define lst1 (list 1 2 3 4))
(define lst2 (list 1 2 3 4))
(define lst3 (list 1 2 3 4))

(test-equal '(4 3 2 1) (append-reverse! lst1 '()))
(test-equal '(4 3 2 1 5 6) (append-reverse! lst2 '(5 6)))
(test-equal '(4 3 2 1 . 5) (append-reverse! lst3 5))

(test-error-tail type-exception? (append-reverse! #f '(5 6)))

(test-error-tail wrong-number-of-arguments-exception? (append-reverse! lst1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (append-reverse! lst1 '() #f))
