(include "#.scm")

(test-eqv 0. (##fllog 1.))
(test-approximate 1. (##fllog 2.718281828459045) 1e-12)
(test-approximate -1. (##fllog .36787944117144233) 1e-12)
(test-approximate 2. (##fllog 4. 2.) 1e-12)

(test-eqv 0. (fllog 1.))
(test-approximate 1. (fllog 2.718281828459045) 1e-12)
(test-approximate -1. (fllog .36787944117144233) 1e-12)
(test-approximate 2. (fllog 4. 2.) 1e-12)

(test-error-tail type-exception? (fllog 0))
(test-error-tail type-exception? (fllog 1/2))
(test-error-tail type-exception? (fllog 'a))
(test-error-tail type-exception? (fllog 0 2.))
(test-error-tail type-exception? (fllog 1/2 2.))
(test-error-tail type-exception? (fllog 'a 2.))
(test-error-tail type-exception? (fllog 2. 0))
(test-error-tail type-exception? (fllog 2. 1/2))
(test-error-tail type-exception? (fllog 2. 'a))


(test-error-tail wrong-number-of-arguments-exception? (fllog))
(test-error-tail wrong-number-of-arguments-exception? (fllog 1. 1. 1.))
