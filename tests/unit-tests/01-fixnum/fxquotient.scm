(include "#.scm")

(test-eqv 1 (##fxquotient 1 1))
(test-eqv 2 (##fxquotient 2 1))
(test-eqv 3 (##fxquotient 3 1))
(test-eqv -5 (##fxquotient 5 -1))

(test-eqv 1 (fxquotient 1 1))
(test-eqv 2 (fxquotient 2 1))
(test-eqv 3 (fxquotient 3 1))
(test-eqv -5 (fxquotient 5 -1))

(test-error-tail divide-by-zero-exception? (fxquotient 1 0))

(test-error-tail fixnum-overflow-exception? (fxquotient (##least-fixnum) -1))

(test-error-tail type-exception? (fxquotient 1 0.))
(test-error-tail type-exception? (fxquotient .5 1))
(test-error-tail type-exception? (fxquotient 1 .5))
(test-error-tail type-exception? (fxquotient 1 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxquotient))
(test-error-tail wrong-number-of-arguments-exception? (fxquotient 1 1 1))
