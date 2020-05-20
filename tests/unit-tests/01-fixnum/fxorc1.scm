(include "#.scm")

(check-eqv? (##fxorc1 11 26) -2)
(check-eqv? (##fxorc1 -12 26) 27)

(check-eqv? (fxorc1 11 26) -2)
(check-eqv? (fxorc1 -12 26) 27)

(check-tail-exn type-exception? (lambda () (fxorc1 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxorc1 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxorc1 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxorc1 1 1/2)))
