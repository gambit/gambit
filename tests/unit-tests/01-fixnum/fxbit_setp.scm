(include "#.scm")

(test-eqv #f (##fxbit-set? 0 0))
(test-eqv #f (##fxbit-set? 1 0))

(test-eqv #f (##fxbit-set? (- (##fixnum-width) 1) 3))
(test-eqv #t (##fxbit-set? (- (##fixnum-width) 1) -3))

(test-eqv #t (##fxbit-set? 10 (##greatest-fixnum)))
(test-eqv #t (##fxbit-set? 28 (##greatest-fixnum)))

(if (fixnum? 2305843009213693951)
    (test-eqv #t (##fxbit-set? 60 2305843009213693951)))

(test-eqv #f (fxbit-set? 0 0))
(test-eqv #f (fxbit-set? 1 0))

(test-eqv #f (fxbit-set? (- (##fixnum-width) 1) 3))
(test-eqv #t (fxbit-set? (- (##fixnum-width) 1) -3))

(test-eqv #t (fxbit-set? 10 (##greatest-fixnum)))
(test-eqv #t (fxbit-set? 28 (##greatest-fixnum)))

(if (fixnum? 2305843009213693951)
    (test-eqv #t (fxbit-set? 60 2305843009213693951)))

(test-error-tail type-exception? (fxbit-set? 0. 1))
(test-error-tail type-exception? (fxbit-set? .5 1))
(test-error-tail type-exception? (fxbit-set? 1 .5))
(test-error-tail type-exception? (fxbit-set? 1 1/2))

(test-error-tail wrong-number-of-arguments-exception? (fxbit-set?))
(test-error-tail wrong-number-of-arguments-exception? (fxbit-set? 1 1 1))
