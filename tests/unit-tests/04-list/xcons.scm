(include "#.scm")

(test-equal '(2 . 1) (xcons 1 2))

(test-error-tail wrong-number-of-arguments-exception? (xcons))
(test-error-tail wrong-number-of-arguments-exception? (xcons 1))
(test-error-tail wrong-number-of-arguments-exception? (xcons 1 2 3))
