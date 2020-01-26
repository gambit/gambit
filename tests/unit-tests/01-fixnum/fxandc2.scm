(include "#.scm")

(check-eqv? (##fxandc2 11 26) 1)
(check-eqv? (##fxandc2 11 -27) 10)

(check-eqv? (fxandc2 11 26) 1)
(check-eqv? (fxandc2 11 -27) 10)

(check-tail-exn type-exception? (lambda () (fxandc2 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxandc2 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxandc2 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxandc2 1 1/2)))
