(include "#.scm")

(check-eqv? (##fxwrapabs -1) 1)
(check-eqv? (##fxwrapabs 0) 0)
(check-eqv? (##fxwrapabs 1) 1)
(check-eqv? (##fxwrapabs 1000) 1000)
(check-eqv? (##fxwrapabs -1000) 1000)
(check-eqv? (##fxwrapabs ##min-fixnum) ##min-fixnum)

(check-eqv? (fxwrapabs -1) 1)
(check-eqv? (fxwrapabs 0) 0)
(check-eqv? (fxwrapabs 1) 1)
(check-eqv? (fxwrapabs 1000) 1000)
(check-eqv? (fxwrapabs -1000) 1000)
(check-eqv? (fxwrapabs ##min-fixnum) ##min-fixnum)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapabs)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapabs 1 2)))

(check-tail-exn type-exception? (lambda () (fxwrapabs 0.0)))
(check-tail-exn type-exception? (lambda () (fxwrapabs 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrapabs 1/2)))
