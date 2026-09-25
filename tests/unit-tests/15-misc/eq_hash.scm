(include "#.scm")

(test-assert (fixnum? (eq?-hash 1)))
(test-assert (fixnum? (equal?-hash '(1 2))))
(test-assert (fixnum? (eqv?-hash 3)))

(test-equal (eq?-hash 1) (eq?-hash 1))
(test-equal (equal?-hash '(1 2)) (equal?-hash '(1 2)))
(test-equal (eqv?-hash 3) (eqv?-hash 3))

(test-error-tail wrong-number-of-arguments-exception? (eq?-hash))
(test-error-tail wrong-number-of-arguments-exception? (eq?-hash 1 2))
(test-error-tail wrong-number-of-arguments-exception? (equal?-hash))
(test-error-tail wrong-number-of-arguments-exception? (equal?-hash 1 2))
(test-error-tail wrong-number-of-arguments-exception? (eqv?-hash))
(test-error-tail wrong-number-of-arguments-exception? (eqv?-hash 1 2))
