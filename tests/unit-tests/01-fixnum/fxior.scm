(include "#.scm")

(test-eqv 0 (##fxior))
(test-eqv 1 (##fxior 1))
(test-eqv -9 (##fxior 33 22 -11))
(test-eqv -1 (##fxior (##least-fixnum) (##greatest-fixnum)))

(test-eqv 0 (fxior))
(test-eqv 1 (fxior 1))
(test-eqv -9 (fxior 33 22 -11))
(test-eqv -1 (fxior (##least-fixnum) (##greatest-fixnum)))

(test-error-tail type-exception? (fxior 0.))
(test-error-tail type-exception? (fxior .5))
(test-error-tail type-exception? (fxior 1/2))
