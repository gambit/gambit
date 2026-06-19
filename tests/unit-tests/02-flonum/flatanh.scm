(include "#.scm")

(test-approximate 0.0 (flatanh 0.) 1e-12)
(test-approximate 0.5493061443340549 (flatanh 0.5) 1e-12)
(test-approximate -0.5493061443340549 (flatanh -0.5) 1e-12)

(test-error-tail type-exception? (flatanh 1))
(test-error-tail type-exception? (flatanh 1/2))
(test-error-tail type-exception? (flatanh 'a))
