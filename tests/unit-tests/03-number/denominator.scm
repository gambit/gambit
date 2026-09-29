(include "#.scm")

(test-eqv 8. (##denominator .375))
(test-eqv 8 (##denominator 3/8))
(test-eqv 3 (##denominator 2/3))

(test-eqv 8. (denominator .375))
(test-eqv 8 (denominator 3/8))
(test-eqv 3 (denominator 2/3))

(test-error-tail type-exception? (denominator 'a))
(test-error-tail type-exception? (denominator +i))
(test-error-tail type-exception? (denominator #\a))

(test-error-tail wrong-number-of-arguments-exception? (denominator))
(test-error-tail wrong-number-of-arguments-exception? (denominator 1. 1.))
