(include "#.scm")

(test-eqv #t (##flzero? 0.))
(test-eqv #t (##flzero? -0.))
(test-eqv #f (##flzero? 1.5))
(test-eqv #f (##flzero? -1.5))
(test-eqv #f (##flzero? +inf.0))
(test-eqv #f (##flzero? -inf.0))

(test-eqv #t (flzero? 0.))
(test-eqv #t (flzero? -0.))
(test-eqv #f (flzero? 1.5))
(test-eqv #f (flzero? -1.5))
(test-eqv #f (flzero? +inf.0))
(test-eqv #f (flzero? -inf.0))

(test-error-tail wrong-number-of-arguments-exception? (flzero?))
(test-error-tail wrong-number-of-arguments-exception? (flzero? 1. .5))

(test-error-tail type-exception? (flzero? 1/2))
(test-error-tail type-exception? (flzero? 0))
