(include "#.scm")

(test-eqv #t (##fxodd? 1))
(test-eqv #f (##fxodd? 0))

(test-eqv #t (fxodd? 1))
(test-eqv #f (fxodd? 0))

(test-error-tail type-exception? (fxodd? 0.))
(test-error-tail type-exception? (fxodd? .5))
(test-error-tail type-exception? (fxodd? 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxodd?))
(test-error-tail wrong-number-of-arguments-exception? (fxodd? 2 4))
