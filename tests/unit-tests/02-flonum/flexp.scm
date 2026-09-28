(include "#.scm")

(test-eqv 1. (##flexp 0.))
(test-approximate 2.718281828459045 (##flexp 1.) 1e-12)
(test-approximate .36787944117144233 (##flexp -1.) 1e-12)

(test-eqv 1. (flexp 0.))
(test-approximate 2.718281828459045 (flexp 1.) 1e-12)
(test-approximate .36787944117144233 (flexp -1.) 1e-12)

(test-error-tail type-exception? (flexp 0))
(test-error-tail type-exception? (flexp 1/2))
(test-error-tail type-exception? (flexp 'a))

(test-error-tail wrong-number-of-arguments-exception? (flexp))
(test-error-tail wrong-number-of-arguments-exception? (flexp 1. 1.))
