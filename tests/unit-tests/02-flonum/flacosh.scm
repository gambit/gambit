(include "#.scm")

(test-approximate 0. (##flacosh 1.) 1e-12)
(test-approximate .9624236501192069 (##flacosh 1.5) 1e-12)
(test-approximate 2.941657314651186 (##flacosh 9.5) 1e-12)

(test-approximate 0. (flacosh 1.) 1e-12)
(test-approximate .9624236501192069 (flacosh 1.5) 1e-12)
(test-approximate 2.941657314651186 (flacosh 9.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flacosh))
(test-error-tail wrong-number-of-arguments-exception? (flacosh 1. 2.))

(test-error-tail type-exception? (flacosh 1))
(test-error-tail type-exception? (flacosh 1/2))
(test-error-tail type-exception? (flacosh 'a))
