(include "#.scm")

(test-approximate 0.0 (##flsinh 0.) 1e-12)
(test-approximate 0.5210953054937474 (##flsinh 0.5) 1e-12)
(test-approximate -0.5210953054937474 (##flsinh -0.5) 1e-12)

(test-approximate 0.0 (flsinh 0.) 1e-12)
(test-approximate 0.5210953054937474 (flsinh 0.5) 1e-12)
(test-approximate -0.5210953054937474 (flsinh -0.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flsinh))
(test-error-tail wrong-number-of-arguments-exception? (flsinh 1.0 2.0 3.0))

(test-error-tail type-exception? (flsinh 0))
(test-error-tail type-exception? (flsinh 1/2))
(test-error-tail type-exception? (flsinh 'a))
