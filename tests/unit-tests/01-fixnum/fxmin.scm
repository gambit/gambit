(include "#.scm")

(check-eqv? (##fxmin 1) 1)
(check-eqv? (##fxmin 1 11 22) 1)
(check-eqv? (##fxmin 1 11 -22) -22)

(check-eqv? (fxmin 1) 1)
(check-eqv? (fxmin 1 11 22) 1)
(check-eqv? (fxmin 1 11 -22) -22)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxmin)))

(check-tail-exn type-exception? (lambda () (fxmin 1/2)))
(check-tail-exn type-exception? (lambda () (fxmin 0.5)))
