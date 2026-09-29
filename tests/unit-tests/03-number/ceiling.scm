(include "#.scm")

(test-eqv 1. (##ceiling 0.5))
(test-eqv -1. (##ceiling -1.5))
(test-eqv 1 (##ceiling #e0.5))
(test-eqv -1 (##ceiling #e-1.5))

(test-eqv 1. (ceiling 0.5))
(test-eqv -1. (ceiling -1.5))
(test-eqv 1 (ceiling #e0.5))
(test-eqv -1 (ceiling #e-1.5))

(test-error-tail type-exception? (flceiling 'a))

(test-error-tail wrong-number-of-arguments-exception? (ceiling))
(test-error-tail wrong-number-of-arguments-exception? (ceiling 1. 1.))
