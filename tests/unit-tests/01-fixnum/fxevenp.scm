(include "#.scm")

(check-eqv? (##fxeven? 0) #t)
(check-eqv? (##fxeven? 1) #f)

(check-eqv? (fxeven? 0) #t)
(check-eqv? (fxeven? 1) #f)

(check-tail-exn type-exception? (lambda () (fxeven? 0.5)))
(check-tail-exn type-exception? (lambda () (fxeven? 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxeven?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxeven? 1 5)))
