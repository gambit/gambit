(include "#.scm")

(test-eqv #t (##fxpositive? (##greatest-fixnum)))
(test-eqv #f (##fxpositive? (##least-fixnum)))

(test-eqv #t (fxpositive? (##greatest-fixnum)))
(test-eqv #f (fxpositive? (##least-fixnum)))

(test-error-tail type-exception? (fxpositive? 0.))
(test-error-tail type-exception? (fxpositive? .5))
(test-error-tail type-exception? (fxpositive? 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxpositive?))
(test-error-tail wrong-number-of-arguments-exception? (fxpositive? 2 -4))
