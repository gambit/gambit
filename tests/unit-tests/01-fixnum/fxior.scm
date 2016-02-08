(include "#.scm")

(check-eqv? (##fxior) 0)
(check-eqv? (##fxior 1) 1)
(check-eqv? (##fxior 33 22 -11) -9)
(check-eqv? (##fxior ##min-fixnum ##max-fixnum) -1)

(check-eqv? (fxior) 0)
(check-eqv? (fxior 1) 1)
(check-eqv? (fxior 33 22 -11) -9)
(check-eqv? (fxior ##min-fixnum ##max-fixnum) -1)

(check-tail-exn type-exception? (lambda () (fxior 0.5)))
(check-tail-exn type-exception? (lambda () (fxior 1/2)))
