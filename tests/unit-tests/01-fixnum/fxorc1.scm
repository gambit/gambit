(include "#.scm")

(test-eqv -2 (##fxorc1 11 26))
(test-eqv 27 (##fxorc1 -12 26))

(test-eqv -2 (fxorc1 11 26))
(test-eqv 27 (fxorc1 -12 26))

(test-error-tail type-exception? (fxorc1 0. 1))
(test-error-tail type-exception? (fxorc1 .5 1))
(test-error-tail type-exception? (fxorc1 1 .5))
(test-error-tail type-exception? (fxorc1 1 1/2))
