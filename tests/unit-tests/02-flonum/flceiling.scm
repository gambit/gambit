(include "#.scm")

(test-eqv 1. (##flceiling 0.5))
(test-eqv -1. (##flceiling -1.5))

(test-eqv 1. (flceiling 0.5))
(test-eqv -1. (flceiling -1.5))

(test-error-tail type-exception? (flceiling 0))
(test-error-tail type-exception? (flceiling 1/2))

(test-error-tail wrong-number-of-arguments-exception? (flceiling))
(test-error-tail wrong-number-of-arguments-exception? (flceiling 1. 1.))
