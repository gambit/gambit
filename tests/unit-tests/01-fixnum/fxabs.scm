(include "#.scm")

(test-eqv 0 (##fxabs 0))
(test-eqv 1 (##fxabs 1))
(test-eqv 100 (##fxabs 100))
(test-eqv 100 (##fxabs -100))

(test-eqv 0 (fxabs 0))
(test-eqv 1 (fxabs 1))
(test-eqv 100 (fxabs 100))
(test-eqv 100 (fxabs -100))

(test-error-tail fixnum-overflow-exception? (fxabs (##least-fixnum)))

(test-error-tail type-exception? (fxabs 0.))
(test-error-tail type-exception? (fxabs .5))
(test-error-tail type-exception? (fxabs 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxabs))
(test-error-tail wrong-number-of-arguments-exception? (fxabs 1 1))
