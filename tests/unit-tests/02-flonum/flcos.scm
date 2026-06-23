(include "#.scm")

(test-approximate .5403023058681398 (##flcos -1.) 1e-12)
(test-approximate .8775825618903728 (##flcos -.5) 1e-12)
(test-approximate 1. (##flcos -0.) 1e-12)
(test-approximate 1. (##flcos 0.) 1e-12)
(test-approximate .8775825618903728 (##flcos .5) 1e-12)
(test-approximate .5403023058681398 (##flcos 1.) 1e-12)

(test-approximate .5403023058681398 (flcos -1.) 1e-12)
(test-approximate .8775825618903728 (flcos -.5) 1e-12)
(test-approximate 1. (flcos -0.) 1e-12)
(test-approximate 1. (flcos 0.) 1e-12)
(test-approximate .8775825618903728 (flcos .5) 1e-12)
(test-approximate .5403023058681398 (flcos 1.) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flcos))
(test-error-tail wrong-number-of-arguments-exception? (flcos 1. 2. 3.))

(test-error-tail type-exception? (flcos 0))
(test-error-tail type-exception? (flcos 1/2))
(test-error-tail type-exception? (flcos 'a))
