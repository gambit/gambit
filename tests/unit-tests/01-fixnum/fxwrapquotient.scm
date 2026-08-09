(include "#.scm")

(test-eqv 1 (##fxwrapquotient 1 1))
(test-eqv 2 (##fxwrapquotient 2 1))
(test-eqv 3 (##fxwrapquotient 3 1))
(test-eqv -5 (##fxwrapquotient 5 -1))
(test-eqv (##least-fixnum) (##fxwrapquotient (##least-fixnum) -1))

(test-eqv 1 (fxwrapquotient 1 1))
(test-eqv 2 (fxwrapquotient 2 1))
(test-eqv 3 (fxwrapquotient 3 1))
(test-eqv -5 (fxwrapquotient 5 -1))
(test-eqv (##least-fixnum) (fxwrapquotient (##least-fixnum) -1))

(test-error-tail divide-by-zero-exception? (fxwrapquotient 1 0))

(test-error-tail type-exception? (fxwrapquotient 1 0.))
(test-error-tail type-exception? (fxwrapquotient .5 1))
(test-error-tail type-exception? (fxwrapquotient 1 .5))
(test-error-tail type-exception? (fxwrapquotient 1 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxwrapquotient))
(test-error-tail wrong-number-of-arguments-exception? (fxwrapquotient 1 1 1))
