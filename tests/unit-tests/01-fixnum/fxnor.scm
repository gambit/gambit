(include "#.scm")

(test-eqv -28 (##fxnor 11 26))
(test-eqv 16 (##fxnor 11 -27))

(test-eqv -28 (fxnor 11 26))
(test-eqv 16 (fxnor 11 -27))

(test-error-tail type-exception? (fxnor 0. 1))
(test-error-tail type-exception? (fxnor .5 1))
(test-error-tail type-exception? (fxnor 1 .5))
(test-error-tail type-exception? (fxnor 1 1/2))
