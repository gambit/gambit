(include "#.scm")

(test-eqv 0. (##flabs 0.))
(test-eqv 1. (##flabs 1.))
(test-eqv 100. (##flabs 100.))
(test-eqv 100. (##flabs -100.))
(test-eqv +inf.0 (##flabs +inf.0))
(test-eqv +inf.0 (##flabs -inf.0))

(test-eqv 0. (flabs 0.))
(test-eqv 1. (flabs 1.))
(test-eqv 100. (flabs 100.))
(test-eqv 100. (flabs -100.))
(test-eqv +inf.0 (flabs +inf.0))
(test-eqv +inf.0 (flabs -inf.0))

(test-error-tail type-exception? (flabs 0))
(test-error-tail type-exception? (flabs 1/2))

(test-error-tail wrong-number-of-arguments-exception? (flabs))
(test-error-tail wrong-number-of-arguments-exception? (flabs 1. 1.))
