(include "#.scm")

(check-eqv? (##fxnot 0)                      -1)
(check-eqv? (##fxnot -1)                      0)
(check-eqv? (##fxnot (##least-fixnum)) (##greatest-fixnum))
(check-eqv? (##fxnot (##greatest-fixnum)) (##least-fixnum))

(check-eqv? (fxnot 0)                      -1)
(check-eqv? (fxnot -1)                      0)
(check-eqv? (fxnot (##least-fixnum)) (##greatest-fixnum))
(check-eqv? (fxnot (##greatest-fixnum)) (##least-fixnum))

(check-tail-exn type-exception? (lambda () (fxnot 0.0)))
(check-tail-exn type-exception? (lambda () (fxnot 0.5)))
(check-tail-exn type-exception? (lambda () (fxnot 1/3)))
