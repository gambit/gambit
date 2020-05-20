(include "#.scm")

(check-eqv? (##fxnand 11 26) -11)
(check-eqv? (##fxnand 11 -27) -2)

(check-eqv? (fxnand 11 26) -11)
(check-eqv? (fxnand 11 -27) -2)

(check-tail-exn type-exception? (lambda () (fxnand 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxnand 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxnand 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxnand 1 1/2)))
