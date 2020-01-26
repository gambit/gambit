(include "#.scm")

(check-eqv? (##fxnor 11 26) -28)
(check-eqv? (##fxnor 11 -27) 16)

(check-eqv? (fxnor 11 26) -28)
(check-eqv? (fxnor 11 -27) 16)

(check-tail-exn type-exception? (lambda () (fxnor 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxnor 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxnor 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxnor 1 1/2)))
