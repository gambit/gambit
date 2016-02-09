(include "#.scm")

(check-eqv? (##fxabs 0) 0)
(check-eqv? (##fxabs 1) 1)
(check-eqv? (##fxabs 100) 100)
(check-eqv? (##fxabs -100) 100)

(check-eqv? (fxabs 0) 0)
(check-eqv? (fxabs 1) 1)
(check-eqv? (fxabs 100) 100)
(check-eqv? (fxabs -100) 100)

(check-tail-exn fixnum-overflow-exception? (lambda () (fxabs ##min-fixnum)))

(check-tail-exn type-exception? (lambda () (fxabs 0.0)))
(check-tail-exn type-exception? (lambda () (fxabs 0.5)))
(check-tail-exn type-exception? (lambda () (fxabs 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxabs)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxabs 1 1)))
