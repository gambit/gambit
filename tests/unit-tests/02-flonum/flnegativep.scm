(include "#.scm")

(test-eqv #t (##flnegative? -inf.0))
(test-eqv #f (##flnegative? +inf.0))
(test-eqv #f (##flnegative? 0.))
(test-eqv #f (##flnegative? -0.))
(test-eqv #t (##flnegative? -1.))
(test-eqv #f (##flnegative? 1.))

(test-eqv #t (flnegative? -inf.0))
(test-eqv #f (flnegative? +inf.0))
(test-eqv #f (flnegative? 0.))
(test-eqv #f (flnegative? -0.))
(test-eqv #t (flnegative? -1.))
(test-eqv #f (flnegative? 1.))

(test-error-tail wrong-number-of-arguments-exception? (flnegative?))
(test-error-tail wrong-number-of-arguments-exception? (flnegative? 1. 2.))

(test-error-tail type-exception? (flnegative? 1))
(test-error-tail type-exception? (flnegative? 1/2))
