(include "#.scm")

(test-eqv 3. (##numerator .375))
(test-eqv 3 (##numerator 3/8))
(test-eqv 2 (##numerator 2/3))

(test-eqv 3. (numerator .375))
(test-eqv 3 (numerator 3/8))
(test-eqv 2 (numerator 2/3))

(test-error-tail type-exception? (numerator 'a))
(test-error-tail type-exception? (numerator +i))
(test-error-tail type-exception? (numerator #\a))

(test-error-tail wrong-number-of-arguments-exception? (denominator))
(test-error-tail wrong-number-of-arguments-exception? (denominator 1. 1.))
