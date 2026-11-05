(include "#.scm")

(test-eqv 0. (##flround 0.5))      ;; assume round to even, positives round to +0, negatives to -0.
(test-eqv 1. (##flround 0.75))
(test-eqv 2. (##flround 1.5))
(test-eqv -0. (##flround -0.5))
(test-eqv -1. (##flround -0.75))
(test-eqv -2. (##flround -1.5))

(test-eqv 0. (flround 0.5))      ;; assume round to even, positives round to +0, negatives to -0.
(test-eqv 1. (flround 0.75))
(test-eqv 2. (flround 1.5))
(test-eqv -0. (flround -0.5))
(test-eqv -1. (flround -0.75))
(test-eqv -2. (flround -1.5))

(test-error-tail type-exception? (flround 0))
(test-error-tail type-exception? (flround 1/2))
(test-error-tail type-exception? (flround 'a))

(test-error-tail wrong-number-of-arguments-exception? (flround))
(test-error-tail wrong-number-of-arguments-exception? (flround 1. 1.))
