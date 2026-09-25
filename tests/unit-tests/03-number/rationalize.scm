(include "#.scm")

(test-equal 1/2 (rationalize 3/10 1/4))
(test-equal .5 (rationalize .3 1/4))
(test-error-tail type-exception? (rationalize 'a 1/4))
(test-error-tail wrong-number-of-arguments-exception? (rationalize))
(test-error-tail wrong-number-of-arguments-exception? (rationalize 1))
