(include "#.scm")

(test-eqv -inf.0 (##flmin +inf.0 -inf.0))
(test-eqv 0. (##flmin -0. 0.))
(test-eqv 0. (##flmin 0.))
(test-eqv 0. (##flmin 0. 1.5))
(test-eqv -1.5 (##flmin 2. -1.5 .5))
(test-eqv -3. (##flmin -3. 2. 1.5))

(test-eqv -inf.0 (flmin +inf.0 -inf.0))
(test-eqv 0. (flmin -0. 0.))
(test-eqv 0. (flmin 0.))
(test-eqv 0. (flmin 0. 1.5))
(test-eqv -1.5 (flmin 2. -1.5 .5))
(test-eqv -3. (flmin -3. 2. 1.5))

(test-error-tail wrong-number-of-arguments-exception? (flmin))

(test-error-tail type-exception? (flmin 1 1.))
(test-error-tail type-exception? (flmin 1. 1))
(test-error-tail type-exception? (flmin 1/2))
