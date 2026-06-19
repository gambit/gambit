(include "#.scm")

(test-eqv  0.0 (flnumerator  0.0))
(test-eqv -0.0 (flnumerator -0.0))
(test-eqv  1.0 (flnumerator  0.5))
(test-eqv  1.0 (flnumerator  1.0))
(test-eqv  3.0 (flnumerator  1.5))
(test-eqv  7.0 (flnumerator  3.5))
(test-eqv  5.0 (flnumerator  5.0))

(test-error-tail wrong-number-of-arguments-exception? (flnumerator))
(test-error-tail wrong-number-of-arguments-exception? (flnumerator 1.0 2.0))

(test-error-tail type-exception? (flnumerator 1))
(test-error-tail type-exception? (flnumerator 1/2))
(test-error-tail type-exception? (flnumerator -inf.0))
(test-error-tail type-exception? (flnumerator +inf.0))
