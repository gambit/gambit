(include "#.scm")

(check-eqv? (flnumerator 0.0)   0.)
(check-eqv? (flnumerator -0.0) -0.)
(check-eqv? (flnumerator 0.5)   1.)
(check-eqv? (flnumerator 1.0)   1.)
(check-eqv? (flnumerator 1.5)   3.)
(check-eqv? (flnumerator 3.5)   7.)
(check-eqv? (flnumerator 5.0)   5.)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flnumerator)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flnumerator 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flnumerator 1)))
(check-tail-exn type-exception? (lambda () (flnumerator 1/2)))
(check-tail-exn type-exception? (lambda () (flnumerator -inf.0)))
(check-tail-exn type-exception? (lambda () (flnumerator +inf.0)))
