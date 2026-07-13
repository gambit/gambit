(include "#.scm")

(test-approximate 1.0 (##flcosh 0.) 1e-12)
(test-approximate 1.1276259652063807 (##flcosh 0.5) 1e-12)
(test-approximate 1.1276259652063807 (##flcosh -0.5) 1e-12)

(test-approximate 1.0 (flcosh 0.) 1e-12)
(test-approximate 1.1276259652063807 (flcosh 0.5) 1e-12)
(test-approximate 1.1276259652063807 (flcosh -0.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flcosh))
(test-error-tail wrong-number-of-arguments-exception? (flcosh 1.0 2.0))

(test-error-tail type-exception? (flcosh 0))
(test-error-tail type-exception? (flcosh 1/2))
(test-error-tail type-exception? (flcosh 'a))
