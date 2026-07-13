(include "#.scm")

(test-approximate -1.557407724654902 (##fltan -1.0) 1e-12)
(test-approximate -0.5463024898437905 (##fltan -0.5) 1e-12)
(test-approximate -0.0 (##fltan -0.0) 1e-12)
(test-approximate 0.0 (##fltan 0.0) 1e-12)
(test-approximate 0.5463024898437905 (##fltan 0.5) 1e-12)
(test-approximate 1.557407724654902 (##fltan 1.0) 1e-12)

(test-approximate -1.557407724654902 (fltan -1.0) 1e-12)
(test-approximate -0.5463024898437905 (fltan -0.5) 1e-12)
(test-approximate -0.0 (fltan -0.0) 1e-12)
(test-approximate 0.0 (fltan 0.0) 1e-12)
(test-approximate 0.5463024898437905 (fltan 0.5) 1e-12)
(test-approximate 1.557407724654902 (fltan 1.0) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (fltan))
(test-error-tail wrong-number-of-arguments-exception? (fltan 1.0 2.0 3.0))

(test-error-tail type-exception? (fltan 0))
(test-error-tail type-exception? (fltan 1/2))
(test-error-tail type-exception? (fltan 'a))
