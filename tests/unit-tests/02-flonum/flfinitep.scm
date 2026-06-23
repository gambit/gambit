(include "#.scm")

(test-eqv #f (##flfinite? +inf.0))
(test-eqv #f (##flfinite? -inf.0))
(test-eqv #t (##flfinite? -0.))
(test-eqv #t (##flfinite? 0.))
(test-eqv #t (##flfinite? 1.5))
(test-eqv #t (##flfinite? -1.5))

(test-eqv #f (flfinite? +inf.0))
(test-eqv #f (flfinite? -inf.0))
(test-eqv #t (flfinite? -0.))
(test-eqv #t (flfinite? 0.))
(test-eqv #t (flfinite? 1.5))
(test-eqv #t (flfinite? -1.5))

(test-error-tail wrong-number-of-arguments-exception? (flfinite?))
(test-error-tail wrong-number-of-arguments-exception? (flfinite? 1. 2.))

(test-error-tail type-exception? (flfinite? 1))
(test-error-tail type-exception? (flfinite? 1/2))
