(include "#.scm")

(check-eqv? (##fxorc2 11 26) -17)
(check-eqv? (##fxorc2 11 -27) 27)

(check-eqv? (fxorc2 11 26) -17)
(check-eqv? (fxorc2 11 -27) 27)

(check-tail-exn type-exception? (lambda () (fxorc2 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxorc2 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxorc2 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxorc2 1 1/2)))
