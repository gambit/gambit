(include "#.scm")

(test-eqv 1 (##fxwrapabs -1))
(test-eqv 0 (##fxwrapabs 0))
(test-eqv 1 (##fxwrapabs 1))
(test-eqv 1000 (##fxwrapabs 1000))
(test-eqv 1000 (##fxwrapabs -1000))
(test-eqv (##least-fixnum) (##fxwrapabs (##least-fixnum)))

(test-eqv 1 (fxwrapabs -1))
(test-eqv 0 (fxwrapabs 0))
(test-eqv 1 (fxwrapabs 1))
(test-eqv 1000 (fxwrapabs 1000))
(test-eqv 1000 (fxwrapabs -1000))
(test-eqv (##least-fixnum) (fxwrapabs (##least-fixnum)))

(test-error-tail wrong-number-of-arguments-exception? (fxwrapabs))
(test-error-tail wrong-number-of-arguments-exception? (fxwrapabs 1 2))

(test-error-tail type-exception? (fxwrapabs 0.))
(test-error-tail type-exception? (fxwrapabs .5))
(test-error-tail type-exception? (fxwrapabs 1/2))
