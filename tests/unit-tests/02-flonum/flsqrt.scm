(include "#.scm")

(test-eqv +0. (##flsqrt +0.))  ;; Let's assume IEEE arithmetic for now.
(test-eqv +1. (##flsqrt +1.))
(test-eqv +2. (##flsqrt +4.))
(test-eqv 0.5 (##flsqrt .25))

(test-eqv +0. (flsqrt +0.))  ;; Let's assume IEEE arithmetic for now.
(test-eqv +1. (flsqrt +1.))
(test-eqv +2. (flsqrt +4.))
(test-eqv 0.5 (flsqrt .25))

(test-error-tail type-exception? (flsqrt 0))
(test-error-tail type-exception? (flsqrt 1/2))
(test-error-tail type-exception? (flsqrt 'a))

(test-error-tail wrong-number-of-arguments-exception? (flsqrt))
(test-error-tail wrong-number-of-arguments-exception? (flsqrt 1. 1.))
