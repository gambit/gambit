(include "#.scm")

(test-eqv 0.0 (##flasin 0.))
(test-approximate .5235987755982988 (##flasin 0.5) 1e-12)
(test-approximate -.5235987755982988 (##flasin -0.5) 1e-12)

(test-eqv 0.0 (flasin 0.))
(test-approximate .5235987755982988 (flasin 0.5) 1e-12)
(test-approximate -.5235987755982988 (flasin -0.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flasin))
(test-error-tail wrong-number-of-arguments-exception? (flasin 0.5 2.0))

(test-error-tail type-exception? (flasin 1))
(test-error-tail type-exception? (flasin 1/2))
(test-error-tail type-exception? (flasin 'a))
