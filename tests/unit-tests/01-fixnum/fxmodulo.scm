(include "#.scm")

(check-eqv? (##fxmodulo 3 1) 0)
(check-eqv? (##fxmodulo 3 2) 1)
(check-eqv? (##fxmodulo 3 3) 0)

(check-eqv? (fxmodulo 3 1) 0)
(check-eqv? (fxmodulo 3 2) 1)
(check-eqv? (fxmodulo 3 3) 0)

(check-tail-exn divide-by-zero-exception? (lambda () (fxmodulo 1 0)))

(check-tail-exn type-exception? (lambda () (fxmodulo 1 0.0)))
(check-tail-exn type-exception? (lambda () (fxmodulo 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxmodulo 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxmodulo 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxmodulo)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxmodulo 1 1 1)))
