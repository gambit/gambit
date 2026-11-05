(include "#.scm")

(test-eqv 0 (##max 0))
(test-eqv 1 (##max 0 1))
(test-eqv 1. (##max 0. 1))
(test-eqv 1. (##max 0 1.))
(test-eqv 1. (##max -1 0 1.))
(test-approximate 1.3333333333333333333 (##max 1. 4/3) 1e-12)
(test-eqv 4/3 (##max 1 4/3))

(test-eqv 0 (max 0))
(test-eqv 1 (max 0 1))
(test-eqv 1. (max 0. 1))
(test-eqv 1. (max 0 1.))
(test-eqv 1. (max -1 0 1.))
(test-approximate 1.3333333333333333333 (max 1. 4/3) 1e-12)
(test-eqv 4/3 (max 1 4/3))

(test-error-tail type-exception? (max 'a))
(test-error-tail type-exception? (max +i))
(test-error-tail type-exception? (max #\a))

(test-error-tail wrong-number-of-arguments-exception? (max))
