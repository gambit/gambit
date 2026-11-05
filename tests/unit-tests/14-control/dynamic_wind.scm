(include "#.scm")

(test-eqv 2 (dynamic-wind (lambda () 1) (lambda () 2) (lambda () 3)))
(test-error-tail type-exception? (dynamic-wind 1 (lambda () 2) (lambda () 3)))
(test-error-tail wrong-number-of-arguments-exception? (dynamic-wind))
(test-error-tail wrong-number-of-arguments-exception? (dynamic-wind (lambda () 1) (lambda () 2)))
