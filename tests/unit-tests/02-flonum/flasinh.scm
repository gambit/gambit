(include "#.scm")

(test-approximate 0.0 (flasinh 0.) 1e-12)
(test-approximate 0.48121182505960347 (flasinh 0.5) 1e-12)
(test-approximate -0.48121182505960347 (flasinh -0.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flasinh))
(test-error-tail wrong-number-of-arguments-exception? (flasinh 0.5 2.0))

(test-error-tail type-exception? (flasinh 1))
(test-error-tail type-exception? (flasinh 1/2))
(test-error-tail type-exception? (flasinh 'a))
