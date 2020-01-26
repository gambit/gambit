(include "#.scm")

(check-eqv? (##fxandc1 11 26) 16)
(check-eqv? (##fxandc1 -12 26) 10)

(check-eqv? (fxandc1 11 26) 16)
(check-eqv? (fxandc1 -12 26) 10)

(check-tail-exn type-exception? (lambda () (fxandc1 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxandc1 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxandc1 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxandc1 1 1/2)))
