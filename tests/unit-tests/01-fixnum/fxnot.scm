(include "#.scm")

(check-eqv? (##fxnot 0)                      -1)
(check-eqv? (##fxnot -1)                      0)
(check-eqv? (##fxnot ##min-fixnum) ##max-fixnum)
(check-eqv? (##fxnot ##max-fixnum) ##min-fixnum)

(check-eqv? (fxnot 0)                      -1)
(check-eqv? (fxnot -1)                      0)
(check-eqv? (fxnot ##min-fixnum) ##max-fixnum)
(check-eqv? (fxnot ##max-fixnum) ##min-fixnum)

(check-tail-exn type-exception? (lambda () (fxnot 0.0)))
(check-tail-exn type-exception? (lambda () (fxnot 0.5)))
(check-tail-exn type-exception? (lambda () (fxnot 1/3)))
