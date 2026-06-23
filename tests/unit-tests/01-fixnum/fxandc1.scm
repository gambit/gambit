(include "#.scm")

(test-eqv 16 (##fxandc1 11 26))
(test-eqv 10 (##fxandc1 -12 26))

(test-eqv 16 (fxandc1 11 26))
(test-eqv 10 (fxandc1 -12 26))

(test-error-tail type-exception? (fxandc1 0. 1))
(test-error-tail type-exception? (fxandc1 .5 1))
(test-error-tail type-exception? (fxandc1 1 .5))
(test-error-tail type-exception? (fxandc1 1 1/2))
