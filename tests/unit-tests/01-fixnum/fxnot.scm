(include "#.scm")

(test-eqv -1 (##fxnot 0))
(test-eqv 0 (##fxnot -1))
(test-eqv (##greatest-fixnum) (##fxnot (##least-fixnum)))
(test-eqv (##least-fixnum) (##fxnot (##greatest-fixnum)))

(test-eqv -1 (fxnot 0))
(test-eqv 0 (fxnot -1))
(test-eqv (##greatest-fixnum) (fxnot (##least-fixnum)))
(test-eqv (##least-fixnum) (fxnot (##greatest-fixnum)))

(test-error-tail type-exception? (fxnot 0.))
(test-error-tail type-exception? (fxnot .5))
(test-error-tail type-exception? (fxnot 1/3))
