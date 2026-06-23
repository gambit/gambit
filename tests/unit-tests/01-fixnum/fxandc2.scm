(include "#.scm")

(test-eqv 1 (##fxandc2 11 26))
(test-eqv 10 (##fxandc2 11 -27))

(test-eqv 1 (fxandc2 11 26))
(test-eqv 10 (fxandc2 11 -27))

(test-error-tail type-exception? (fxandc2 0. 1))
(test-error-tail type-exception? (fxandc2 .5 1))
(test-error-tail type-exception? (fxandc2 1 .5))
(test-error-tail type-exception? (fxandc2 1 1/2))
