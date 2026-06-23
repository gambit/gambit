(include "#.scm")

(test-eqv +inf.0 (##flmax +inf.0 -inf.0))
(test-eqv 0. (##flmax -0. 0.))
(test-eqv 0. (##flmax 0.))
(test-eqv 1.5 (##flmax 0. 1.5))
(test-eqv 2. (##flmax 2. -1.5 .5))
(test-eqv 2. (##flmax -3. 2. 1.5))

(test-eqv +inf.0 (flmax +inf.0 -inf.0))
(test-eqv 0. (flmax -0. 0.))
(test-eqv 0. (flmax 0.))
(test-eqv 1.5 (flmax 0. 1.5))
(test-eqv 2. (flmax 2. -1.5 .5))
(test-eqv 2. (flmax -3. 2. 1.5))

(test-error-tail wrong-number-of-arguments-exception? (flmax))

(test-error-tail type-exception? (flmax 1 1.))
(test-error-tail type-exception? (flmax 1. 1))
(test-error-tail type-exception? (flmax 1/2))
