(include "#.scm")

(test-eqv 1. (##fl/ 1.))
(test-eqv .5 (##fl/ 1. 2.))
(test-eqv .25 (##fl/ 1. 2. 2.))

(test-eqv 1. (fl/ 1.))
(test-eqv .5 (fl/ 1. 2.))
(test-eqv .25 (fl/ 1. 2. 2.))

(test-error-tail type-exception? (fl/ 0))
(test-error-tail type-exception? (fl/ 'a))
(test-error-tail type-exception? (fl/ 1/2))
(test-error-tail type-exception? (fl/ 1. 1))
(test-error-tail type-exception? (fl/ 1 1.))

(test-error-tail wrong-number-of-arguments-exception? (fl/))
