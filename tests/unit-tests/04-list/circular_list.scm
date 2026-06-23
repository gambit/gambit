(include "#.scm")

(define lst1 (circular-list 1))
(define lst2 (circular-list 1 2))
(define lst3 (circular-list 1 2 3))

(test-equal 1 (car lst1))
(test-equal 1 (cadr lst1))
(test-equal 1 (caddr lst1))
(test-equal 1 (cadddr lst1))

(test-equal 1 (car lst2))
(test-equal 2 (cadr lst2))
(test-equal 1 (caddr lst2))
(test-equal 2 (cadddr lst2))

(test-equal 1 (car lst3))
(test-equal 2 (cadr lst3))
(test-equal 3 (caddr lst3))
(test-equal 1 (cadddr lst3))

(test-error-tail wrong-number-of-arguments-exception? (circular-list))
