(include "#.scm")

(test-eqv -17 (##fxorc2 11 26))
(test-eqv 27 (##fxorc2 11 -27))

(test-eqv -17 (fxorc2 11 26))
(test-eqv 27 (fxorc2 11 -27))

(test-error-tail type-exception? (fxorc2 0. 1))
(test-error-tail type-exception? (fxorc2 .5 1))
(test-error-tail type-exception? (fxorc2 1 .5))
(test-error-tail type-exception? (fxorc2 1 1/2))
