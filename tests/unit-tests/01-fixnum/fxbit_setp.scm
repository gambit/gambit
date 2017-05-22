(include "#.scm")

(check-eqv? (##fxbit-set? 0 0) #f)
(check-eqv? (##fxbit-set? 1 0) #f)

(check-eqv? (##fxbit-set? 10 ##max-fixnum) #t)
(check-eqv? (##fxbit-set? 28 ##max-fixnum) #t)

(if (fixnum? 2305843009213693951)
    (check-eqv? (##fxbit-set? 60 2305843009213693951) #t))

(check-eqv? (fxbit-set? 0 0) #f)
(check-eqv? (fxbit-set? 1 0) #f)

(check-eqv? (fxbit-set? 10 ##max-fixnum) #t)
(check-eqv? (fxbit-set? 28 ##max-fixnum) #t)

(if (fixnum? 2305843009213693951)
    (check-eqv? (fxbit-set? 60 2305843009213693951) #t))

(check-tail-exn type-exception? (lambda () (fxbit-set? 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxbit-set? 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxbit-set? 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxbit-set? 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-set?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-set? 1 1 1)))
