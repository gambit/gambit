(include "#.scm")

(test-eqv +inf.0 (##flmax +inf.0 -inf.0))
(test-eqv 0.0    (##flmax -0.0 0.0))
(test-eqv 0.0    (##flmax 0.0))
(test-eqv 1.5    (##flmax 0.0 1.5))
(test-eqv 2.0    (##flmax 2.0 -1.5 0.5))
(test-eqv 2.0    (##flmax -3.0 2.0 1.5))

(test-eqv +inf.0 (flmax +inf.0 -inf.0))
(test-eqv 0.0    (flmax -0.0 0.0))
(test-eqv 0.0    (flmax 0.0))
(test-eqv 1.5    (flmax 0.0 1.5))
(test-eqv 2.0    (flmax 2.0 -1.5 0.5))
(test-eqv 2.0    (flmax -3.0 2.0 1.5))

(test-error-tail wrong-number-of-arguments-exception? (flmax))

(test-error-tail type-exception? (flmax 1 1.0))
(test-error-tail type-exception? (flmax 1.0 1))
(test-error-tail type-exception? (flmax 1/2))
