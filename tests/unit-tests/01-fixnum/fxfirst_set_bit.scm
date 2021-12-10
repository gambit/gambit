(include "#.scm")

(check-eqv? (##fxfirst-set-bit 1) 0)
(check-eqv? (##fxfirst-set-bit 100) 2)
(check-eqv? (##fxfirst-set-bit -1000) 3)

(check-eqv? (fxfirst-set-bit 1) 0)
(check-eqv? (fxfirst-set-bit 100) 2)
(check-eqv? (fxfirst-set-bit -1000) 3)

(check-tail-exn type-exception? (lambda () (fxfirst-set-bit 0.0)))
(check-tail-exn type-exception? (lambda () (fxfirst-set-bit 0.5)))
(check-tail-exn type-exception? (lambda () (fxfirst-set-bit 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxfirst-set-bit)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxfirst-set-bit 1 1)))
