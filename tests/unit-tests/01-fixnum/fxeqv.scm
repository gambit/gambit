(include "#.scm")

(test-eqv -1 (##fxeqv))
(test-eqv 1 (##fxeqv 1))
(test-eqv 105 (##fxeqv 85 204 240))
(test-eqv 0 (##fxeqv (##least-fixnum) (##greatest-fixnum)))

(test-eqv -1 (fxeqv))
(test-eqv 1 (fxeqv 1))
(test-eqv 105 (fxeqv 85 204 240))
(test-eqv 0 (fxeqv (##least-fixnum) (##greatest-fixnum)))

(test-error-tail type-exception? (fxeqv 0.))
(test-error-tail type-exception? (fxeqv .5))
(test-error-tail type-exception? (fxeqv 1/2))
