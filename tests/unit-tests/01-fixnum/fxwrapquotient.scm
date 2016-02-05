(include "#.scm")

(check-eqv? (fxwrapquotient 1 1) 1)
(check-eqv? (fxwrapquotient -3 2) -1)
(check-eqv? (fxwrapquotient -6 -4) 1)
(check-eqv? (fxwrapquotient -8 -4) 2)

(check-tail-exn divide-by-zero-exception? (lambda () (fxwrapquotient 1 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapquotient)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapquotient 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapquotient 1 1 1)))

(check-tail-exn type-exception? (lambda () (fxwrapquotient 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrapquotient 1 1/2)))
