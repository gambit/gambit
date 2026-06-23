(include "#.scm")

(test-eqv 0 (##fxbit-count -1))
(test-eqv 1 (##fxbit-count 1))
(test-eqv 6 (##fxbit-count 1000))

(test-eqv 29 (##fxbit-count 536870911))

(if (fixnum? 2305843009213693951)
    (test-eqv 61 (##fxbit-count 2305843009213693951)))

(test-eqv 0 (fxbit-count -1))
(test-eqv 1 (fxbit-count 1))
(test-eqv 6 (fxbit-count 1000))

(test-eqv 29 (fxbit-count 536870911))

(if (fixnum? 2305843009213693951)
    (test-eqv 61 (fxbit-count 2305843009213693951)))

(test-error-tail type-exception? (fxbit-count 0.))
(test-error-tail type-exception? (fxbit-count .5))
(test-error-tail type-exception? (fxbit-count 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxbit-count))
(test-error-tail wrong-number-of-arguments-exception? (fxbit-count 1 1))
