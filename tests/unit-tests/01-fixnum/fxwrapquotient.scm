(include "#.scm")

(check-eqv? (##fxwrapquotient 1 1) 1)
(check-eqv? (##fxwrapquotient 2 1) 2)
(check-eqv? (##fxwrapquotient 3 1) 3)
(check-eqv? (##fxwrapquotient 5 -1) -5)
(check-eqv? (##fxwrapquotient ##min-fixnum -1) ##min-fixnum)

(check-eqv? (fxwrapquotient 1 1) 1)
(check-eqv? (fxwrapquotient 2 1) 2)
(check-eqv? (fxwrapquotient 3 1) 3)
(check-eqv? (fxwrapquotient 5 -1) -5)
(check-eqv? (fxwrapquotient ##min-fixnum -1) ##min-fixnum)

(check-tail-exn divide-by-zero-exception? (lambda () (fxwrapquotient 1 0)))

(check-tail-exn type-exception? (lambda () (fxwrapquotient 1 0.0)))
(check-tail-exn type-exception? (lambda () (fxwrapquotient 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxwrapquotient 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrapquotient 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapquotient)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrapquotient 1 1 1)))
