(include "#.scm")

(check-eqv? (fldenominator 0.0)  1.0)
(check-eqv? (fldenominator -0.0) 1.0)
(check-eqv? (fldenominator 0.5)  2.0)
(check-eqv? (fldenominator 1.0)  1.0)
(check-eqv? (fldenominator 1.5)  2.0)
(check-eqv? (fldenominator 3.5)  2.0)
(check-eqv? (fldenominator 5.0)  1.0)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fldenominator)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fldenominator 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (fldenominator 1)))
(check-tail-exn type-exception? (lambda () (fldenominator 1/2)))
(check-tail-exn type-exception? (lambda () (fldenominator -inf.0)))
(check-tail-exn type-exception? (lambda () (fldenominator +inf.0)))
