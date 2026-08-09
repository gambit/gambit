(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))

(test-equal '(1 2 . 3) (list-copy lst1))
(test-assert (eq? #f (eq? (list-copy lst1) lst1)))

(test-equal #f (list-copy #f))
(test-equal 'foo (list-copy 'foo))

(test-error-tail wrong-number-of-arguments-exception? (list-copy))
(test-error-tail wrong-number-of-arguments-exception? (list-copy lst1 #f))
