(include "#.scm")

(test-equal '(1 . 2) (cons 1 2))

(test-error-tail wrong-number-of-arguments-exception? (cons))
(test-error-tail wrong-number-of-arguments-exception? (cons 1))
(test-error-tail wrong-number-of-arguments-exception? (cons 1 2 3))
