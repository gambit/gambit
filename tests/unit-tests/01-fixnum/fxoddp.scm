(include "#.scm")

(check-eqv? (##fxodd? 1) #t)
(check-eqv? (##fxodd? 0) #f)

(check-eqv? (fxodd? 1) #t)
(check-eqv? (fxodd? 0) #f)

(check-tail-exn type-exception? (lambda () (fxodd? 0.0)))
(check-tail-exn type-exception? (lambda () (fxodd? 0.5)))
(check-tail-exn type-exception? (lambda () (fxodd? 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxodd?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxodd? 2 4)))
