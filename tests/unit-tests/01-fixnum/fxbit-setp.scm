(include "#.scm")

(check-eqv? (##fxbit-set? 0 0) #f)
(check-eqv? (##fxbit-set? 1 0) #f)
(check-eqv? (##fxbit-set? 30 ##max-fixnum) #t)
(check-eqv? (##fxbit-set? 10 ##max-fixnum) #t)

(check-eqv? (fxbit-set? 0 0) #f)
(check-eqv? (fxbit-set? 1 0) #f)
(check-eqv? (fxbit-set? 30 ##max-fixnum) #t)
(check-eqv? (fxbit-set? 10 ##max-fixnum) #t)

(check-tail-exn type-exception? (lambda () (fxbit-set? 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxbit-set? 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-set?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-set? 1 1 1)))
