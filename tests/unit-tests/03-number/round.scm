(include "#.scm")

(test-eqv 0. (##round 0.5))      ;; assume round to even, positives round to +0, negatives to -0.
(test-eqv 1. (##round 0.75))
(test-eqv 2. (##round 1.5))
(test-eqv -0. (##round -0.5))
(test-eqv -1. (##round -0.75))
(test-eqv -2. (##round -1.5))
(test-eqv 0 (##round #e0.5))
(test-eqv 1 (##round #e0.75))
(test-eqv 2 (##round #e1.5))
(test-eqv -1 (##round #e-0.75))
(test-eqv -2 (##round #e-1.5))

(test-eqv 0. (round 0.5))      ;; assume round to even, positives round to +0, negatives to -0.
(test-eqv 1. (round 0.75))
(test-eqv 2. (round 1.5))
(test-eqv -0. (round -0.5))
(test-eqv -1. (round -0.75))
(test-eqv -2. (round -1.5))
(test-eqv 0 (round #e0.5))
(test-eqv 1 (round #e0.75))
(test-eqv 2 (round #e1.5))
(test-eqv -1 (round #e-0.75))
(test-eqv -2 (round #e-1.5))

(test-error-tail type-exception? (round 'a))
(test-error-tail type-exception? (round +i))
(test-error-tail type-exception? (round #\a))

(test-error-tail wrong-number-of-arguments-exception? (round))
(test-error-tail wrong-number-of-arguments-exception? (round 1. 1.))
