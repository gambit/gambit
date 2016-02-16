(include "#.scm")

(check-eqv? (##flmin +inf.0 -inf.0) -inf.0)
(check-eqv? (##flmin -0.0 0.0)         0.0)
(check-eqv? (##flmin 0.0)              0.0)
(check-eqv? (##flmin 0.0 1.5)          0.0)
(check-eqv? (##flmin 2.0 -1.5 0.5)    -1.5)
(check-eqv? (##flmin -3.0 2.0 1.5)    -3.0)

(check-eqv? (flmin +inf.0 -inf.0)   -inf.0)
(check-eqv? (flmin -0.0 0.0)           0.0)
(check-eqv? (flmin 0.0)                0.0)
(check-eqv? (flmin 0.0 1.5)            0.0)
(check-eqv? (flmin 2.0 -1.5 0.5)      -1.5)
(check-eqv? (flmin -3.0 2.0 1.5)      -3.0)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flmin)))

(check-tail-exn type-exception? (lambda () (flmin 1 1.0)))
(check-tail-exn type-exception? (lambda () (flmin 1.0 1)))
(check-tail-exn type-exception? (lambda () (flmin 1/2)))
