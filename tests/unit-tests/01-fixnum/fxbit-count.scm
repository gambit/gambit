(include "#.scm")

(check-eqv? (##fxbit-count -1) 0)
(check-eqv? (##fxbit-count 1) 1)
(check-eqv? (##fxbit-count 1000) 6)
(check-eqv? (##fxbit-count ##max-fixnum) 61)

(check-eqv? (fxbit-count -1) 0)
(check-eqv? (fxbit-count 1) 1)
(check-eqv? (fxbit-count 1000) 6)
(check-eqv? (fxbit-count ##max-fixnum) 61)

(check-tail-exn type-exception? (lambda () (fxbit-count 0.5)))
(check-tail-exn type-exception? (lambda () (fxbit-count 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-count)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxbit-count 1 1)))
