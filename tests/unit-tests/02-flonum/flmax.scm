(include "#.scm")

(check-eqv? (##flmax +inf.0 -inf.0) +inf.0)
(check-eqv? (##flmax -0.0 0.0)         0.0)
(check-eqv? (##flmax 0.0)              0.0)
(check-eqv? (##flmax 0.0 1.5)          1.5)
(check-eqv? (##flmax 2.0 -1.5 0.5)     2.0)
(check-eqv? (##flmax -3.0 2.0 1.5)     2.0)

(check-eqv? (flmax +inf.0 -inf.0)   +inf.0)
(check-eqv? (flmax -0.0 0.0)           0.0)
(check-eqv? (flmax 0.0)                0.0)
(check-eqv? (flmax 0.0 1.5)            1.5)
(check-eqv? (flmax 2.0 -1.5 0.5)       2.0)
(check-eqv? (flmax -3.0 2.0 1.5)       2.0)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flmax)))

(check-tail-exn type-exception? (lambda () (flmax 1 1.0)))
(check-tail-exn type-exception? (lambda () (flmax 1.0 1)))
(check-tail-exn type-exception? (lambda () (flmax 1/2)))
