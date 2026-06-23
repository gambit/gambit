(include "#.scm")

(test-eqv 1 (##fxmax 1))
(test-eqv 22 (##fxmax 1 11 22))
(test-eqv 11 (##fxmax 1 11 -22))

(test-eqv 1 (fxmax 1))
(test-eqv 22 (fxmax 1 11 22))
(test-eqv 11 (fxmax 1 11 -22))

(test-error-tail wrong-number-of-arguments-exception? (fxmax))

(test-error-tail type-exception? (fxmax 1/2))
(test-error-tail type-exception? (fxmax 0.))
(test-error-tail type-exception? (fxmax .5))
