(include "#.scm")

(test-eqv 1 (##fxmin 1))
(test-eqv 1 (##fxmin 1 11 22))
(test-eqv -22 (##fxmin 1 11 -22))

(test-eqv 1 (fxmin 1))
(test-eqv 1 (fxmin 1 11 22))
(test-eqv -22 (fxmin 1 11 -22))

(test-error-tail wrong-number-of-arguments-exception? (fxmin))

(test-error-tail type-exception? (fxmin 1/2))
(test-error-tail type-exception? (fxmin 0.))
(test-error-tail type-exception? (fxmin .5))
