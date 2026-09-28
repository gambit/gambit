(include "#.scm")

(test-eqv #t (##fl>=))
(test-eqv #t (##fl>= 1.))
(test-eqv #t (##fl>= 1. 1.))
(test-eqv #t (##fl>= 2. 1.))
(test-eqv #f (##fl>= 1. 2.))

(test-eqv #t (fl>=))
(test-eqv #t (fl>= 1.))
(test-eqv #t (fl>= 1. 1.))
(test-eqv #t (fl>= 2. 1.))
(test-eqv #f (fl>= 1. 2.))

(test-error-tail type-exception? (fl>= 0. 1))
(test-error-tail type-exception? (fl>= .5 1))
(test-error-tail type-exception? (fl>= 1 .5))
(test-error-tail type-exception? (fl>= 1/3 1.))
