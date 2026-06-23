(include "#.scm")

(test-eqv -11 (##fxnand 11 26))
(test-eqv -2 (##fxnand 11 -27))

(test-eqv -11 (fxnand 11 26))
(test-eqv -2 (fxnand 11 -27))

(test-error-tail type-exception? (fxnand 0. 1))
(test-error-tail type-exception? (fxnand .5 1))
(test-error-tail type-exception? (fxnand 1 .5))
(test-error-tail type-exception? (fxnand 1 1/2))
