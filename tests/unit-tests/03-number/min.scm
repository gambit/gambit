(include "#.scm")

(test-eqv 0 (##min 0))
(test-eqv 0 (##min 0 1))
(test-eqv 0. (##min 0. 1))
(test-eqv 0. (##min 0 1.))
(test-eqv -1. (##min -1 0 1.))
(test-approximate .3333333333333333333 (##min 1. 1/3) 1e-12)
(test-eqv 1/3 (##min 1 1/3))

(test-eqv 0 (min 0))
(test-eqv 0 (min 0 1))
(test-eqv 0. (min 0. 1))
(test-eqv 0. (min 0 1.))
(test-eqv -1. (min -1 0 1.))
(test-approximate .3333333333333333333 (min 1. 1/3) 1e-12)
(test-eqv 1/3 (min 1 1/3))

(test-error-tail type-exception? (min 'a))
(test-error-tail type-exception? (min +i))
(test-error-tail type-exception? (min #\a))

(test-error-tail wrong-number-of-arguments-exception? (min))
