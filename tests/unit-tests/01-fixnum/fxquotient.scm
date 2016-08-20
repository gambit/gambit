(include "#.scm")

(check-eqv? (##fxquotient 1 1) 1)
(check-eqv? (##fxquotient 2 1) 2)
(check-eqv? (##fxquotient 3 1) 3)
(check-eqv? (##fxquotient 5 -1) -5)

(check-eqv? (fxquotient 1 1) 1)
(check-eqv? (fxquotient 2 1) 2)
(check-eqv? (fxquotient 3 1) 3)
(check-eqv? (fxquotient 5 -1) -5)

(check-tail-exn divide-by-zero-exception? (lambda () (fxquotient 1 0)))

(check-tail-exn fixnum-overflow-exception? (lambda () (fxquotient ##min-fixnum -1)))

(check-tail-exn type-exception? (lambda () (fxquotient 1 0.0)))
(check-tail-exn type-exception? (lambda () (fxquotient 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxquotient 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxquotient 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxquotient)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxquotient 1 1 1)))
