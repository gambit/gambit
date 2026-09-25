(include "#.scm")

(test-eq #t (even? 2))
(test-eq #f (even? 1))
(test-eq #t (odd? 1))
(test-eq #f (odd? 2))
(test-error-tail type-exception? (even? 1/2))
(test-error-tail wrong-number-of-arguments-exception? (even?))
(test-error-tail wrong-number-of-arguments-exception? (odd? 1 2))
