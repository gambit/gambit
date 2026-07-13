(include "#.scm")

(test-eqv #t (##flpositive? +inf.0))
(test-eqv #f (##flpositive? -inf.0))
(test-eqv #f (##flpositive? -0.0))
(test-eqv #f (##flpositive? 0.0))
(test-eqv #t (##flpositive? 1.0))
(test-eqv #f (##flpositive? -1.0))

(test-eqv #t (flpositive? +inf.0))
(test-eqv #f (flpositive? -inf.0))
(test-eqv #f (flpositive? -0.0))
(test-eqv #f (flpositive? 0.0))
(test-eqv #t (flpositive? 1.0))
(test-eqv #f (flpositive? -1.0))

(test-error-tail wrong-number-of-arguments-exception? (flpositive?))
(test-error-tail wrong-number-of-arguments-exception? (flpositive? 1.0 2.0))

(test-error-tail type-exception? (flpositive? 1))
(test-error-tail type-exception? (flpositive? 1/2))
