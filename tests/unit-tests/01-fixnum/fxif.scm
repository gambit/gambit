(include "#.scm")

(check-eqv? (##fxif 0 -1 1) 1)
(check-eqv? (##fxif -1 1 0) 1)
(check-eqv? (##fxif 1 0 -1) -2)

(check-eqv? (fxif 0 -1 1) 1)
(check-eqv? (fxif -1 1 0) 1)
(check-eqv? (fxif 1 0 -1) -2)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxif)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxif 1 1 1 1)))

(check-tail-exn type-exception? (lambda () (fxif 1 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxif 1 1 1/2)))
