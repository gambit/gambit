(include "#.scm")

(test-eqv #t (##fxeven? 0))
(test-eqv #f (##fxeven? 1))

(test-eqv #t (fxeven? 0))
(test-eqv #f (fxeven? 1))

(test-error-tail type-exception? (fxeven? 0.))
(test-error-tail type-exception? (fxeven? .5))
(test-error-tail type-exception? (fxeven? 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxeven?))
(test-error-tail wrong-number-of-arguments-exception? (fxeven? 1 5))
