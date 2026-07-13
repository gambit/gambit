(include "#.scm")

(test-eqv #f (##flinteger? +inf.0))
(test-eqv #f (##flinteger? -inf.0))
(test-eqv #t (##flinteger? -0.0))
(test-eqv #t (##flinteger? 0.0))
(test-eqv #f (##flinteger? 1.5))
(test-eqv #f (##flinteger? -1.5))

(test-eqv #f (flinteger? +inf.0))
(test-eqv #f (flinteger? -inf.0))
(test-eqv #t (flinteger? -0.0))
(test-eqv #t (flinteger? 0.0))
(test-eqv #f (flinteger? 1.5))
(test-eqv #f (flinteger? -1.5))

(test-error-tail wrong-number-of-arguments-exception? (flinteger?))
(test-error-tail wrong-number-of-arguments-exception? (flinteger? 1.0 2.0))

(test-error-tail type-exception? (flinteger? 1))
(test-error-tail type-exception? (flinteger? 1/2))
