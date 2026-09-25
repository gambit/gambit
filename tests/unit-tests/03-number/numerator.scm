(include "#.scm")

(test-eqv 2 (numerator 2/3))
(test-eqv 5 (numerator 5))
(test-error-tail type-exception? (numerator 'a))
(test-error-tail wrong-number-of-arguments-exception? (numerator))
(test-error-tail wrong-number-of-arguments-exception? (numerator 1 2))
