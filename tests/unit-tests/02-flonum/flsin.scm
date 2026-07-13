(include "#.scm")

(test-approximate -0.8414709848078965 (##flsin -1.0) 1e-12)
(test-approximate -0.479425538604203 (##flsin -0.5) 1e-12)
(test-approximate -0.0 (##flsin -0.0) 1e-12)
(test-approximate 0.0 (##flsin 0.0) 1e-12)
(test-approximate 0.479425538604203 (##flsin 0.5) 1e-12)
(test-approximate 0.8414709848078965 (##flsin 1.0) 1e-12)

(test-approximate -0.8414709848078965 (flsin -1.0) 1e-12)
(test-approximate -0.479425538604203 (flsin -0.5) 1e-12)
(test-approximate -0.0 (flsin -0.0) 1e-12)
(test-approximate 0.0 (flsin 0.0) 1e-12)
(test-approximate 0.479425538604203 (flsin 0.5) 1e-12)
(test-approximate 0.8414709848078965 (flsin 1.0) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flsin))
(test-error-tail wrong-number-of-arguments-exception? (flsin 1.0 2.0 3.0))

(test-error-tail type-exception? (flsin 0))
(test-error-tail type-exception? (flsin 1/2))
(test-error-tail type-exception? (flsin 'a))
