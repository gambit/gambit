(include "#.scm")

(check-eqv? (##fxremainder 3 1) 0)
(check-eqv? (##fxremainder 3 2) 1)
(check-eqv? (##fxremainder 3 3) 0)

(check-eqv? (fxremainder 3 1) 0)
(check-eqv? (fxremainder 3 2) 1)
(check-eqv? (fxremainder 3 3) 0)

(check-tail-exn divide-by-zero-exception? (lambda () (fxremainder 1 0)))

(check-tail-exn type-exception? (lambda () (fxremainder 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxremainder 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxremainder)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxremainder 1 1 1)))
