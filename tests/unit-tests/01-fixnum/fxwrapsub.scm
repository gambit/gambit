(include "#.scm")

(check-eqv? (##fxwrap- 11 33)  -22)
(check-eqv? (##fxwrap- 11 -11)  22)
(check-eqv? (##fxwrap- 11 -33)  44)
(check-eqv? (##fxwrap- -11 33) -44)

(check-eqv? (##fxwrap- 11) -11)
(check-eqv? (##fxwrap- 11 22) -11)
(check-eqv? (##fxwrap- 11 22 33) -44)
(check-eqv? (##fxwrap- 11 22 33 44) -88)

(check-eqv? (fxwrap- 11 33)  -22)
(check-eqv? (fxwrap- 11 -11)  22)
(check-eqv? (fxwrap- 11 -33)  44)
(check-eqv? (fxwrap- -11 33) -44)

(check-eqv? (fxwrap- 11) -11)
(check-eqv? (fxwrap- 11 22) -11)
(check-eqv? (fxwrap- 11 22 33) -44)
(check-eqv? (fxwrap- 11 22 33 44) -88)

(check-eqv? (fxwrap- (##least-fixnum) 1) (##greatest-fixnum))
(check-eqv? (fxwrap- 0 (##greatest-fixnum) 1 0) (##least-fixnum))
(check-eqv? (fxwrap- (##greatest-fixnum) -1) (##least-fixnum))
(check-eqv? (fxwrap- 0 (##greatest-fixnum) 1 0) (##least-fixnum))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwrap-)))

(check-tail-exn type-exception? (lambda () (fxwrap- 0.0)))
(check-tail-exn type-exception? (lambda () (fxwrap- 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrap- 0.5 9)))
(check-tail-exn type-exception? (lambda () (fxwrap- 9 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrap- 0.5 3 9)))
(check-tail-exn type-exception? (lambda () (fxwrap- 3 0.5 9)))
(check-tail-exn type-exception? (lambda () (fxwrap- 3 9 0.5)))
