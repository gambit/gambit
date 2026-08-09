(include "#.scm")

(test-eqv #t (##fxnegative? (##least-fixnum)))
(test-eqv #f (##fxnegative? (##greatest-fixnum)))

(test-eqv #t (fxnegative? (##least-fixnum)))
(test-eqv #f (fxnegative? (##greatest-fixnum)))

(test-error-tail type-exception? (fxnegative? 0.))
(test-error-tail type-exception? (fxnegative? .5))
(test-error-tail type-exception? (fxnegative? 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxnegative?))
(test-error-tail wrong-number-of-arguments-exception? (fxnegative? 2 -4))
