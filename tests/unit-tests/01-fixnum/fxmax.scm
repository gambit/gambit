(include "#.scm")

(check-eqv? (##fxmax 1) 1)
(check-eqv? (##fxmax 1 11 22) 22)
(check-eqv? (##fxmax 1 11 -22) 11)

(check-eqv? (fxmax 1) 1)
(check-eqv? (fxmax 1 11 22) 22)
(check-eqv? (fxmax 1 11 -22) 11)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxmax)))

(check-tail-exn type-exception? (lambda () (fxmax 1/2)))
(check-tail-exn type-exception? (lambda () (fxmax 0.5)))
