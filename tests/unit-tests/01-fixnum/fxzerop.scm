(include "#.scm")

(test-eqv #t (##fxzero? 0))
(test-eqv #f (##fxzero? 1))

(test-eqv #t (fxzero? 0))
(test-eqv #f (fxzero? 1))

(test-error-tail type-exception? (fxzero? 0.))
(test-error-tail type-exception? (fxzero? .5))
(test-error-tail type-exception? (fxzero? 1/3))
