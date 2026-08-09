(include "#.scm")

(test-equal 1 (cons* 1))
(test-equal '(1 . 2) (cons* 1 2))
(test-equal '(1 2 . 3) (cons* 1 2 3))
(test-equal '(1 2 3 . 4) (cons* 1 2 3 4))

(test-error-tail wrong-number-of-arguments-exception? (cons*))
