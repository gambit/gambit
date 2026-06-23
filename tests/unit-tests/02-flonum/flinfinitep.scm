(include "#.scm")

(test-eqv #t (##flinfinite? +inf.0))
(test-eqv #t (##flinfinite? -inf.0))
(test-eqv #f (##flinfinite? -0.))
(test-eqv #f (##flinfinite? 0.))
(test-eqv #f (##flinfinite? 1.5))
(test-eqv #f (##flinfinite? -1.5))

(test-eqv #t (flinfinite? +inf.0))
(test-eqv #t (flinfinite? -inf.0))
(test-eqv #f (flinfinite? -0.))
(test-eqv #f (flinfinite? 0.))
(test-eqv #f (flinfinite? 1.5))
(test-eqv #f (flinfinite? -1.5))

(test-error-tail wrong-number-of-arguments-exception? (flinfinite?))
(test-error-tail wrong-number-of-arguments-exception? (flinfinite? 1. 2.))

(test-error-tail type-exception? (flinfinite? 1))
(test-error-tail type-exception? (flinfinite? 1/2))
