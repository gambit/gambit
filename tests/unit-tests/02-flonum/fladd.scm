(include "#.scm")

(check-eqv? (fl+ 1.0 3.5)   4.5)
(check-eqv? (fl+ 1.0 -1.0)  0.0)
(check-eqv? (fl+ 1.0 -3.5) -2.5)
(check-eqv? (fl+ -1.0 3.5)  2.5)

(check-eqv? (fl+) 0.0)
(check-eqv? (fl+ 1.0) 1.0)
(check-eqv? (fl+ 1.0 2.5) 3.5)
(check-eqv? (fl+ 1.0 2.5 3.0) 6.5)
(check-eqv? (fl+ 1.0 2.5 3.0 4.5) 11.0)

(check-tail-exn type-exception? (lambda () (fl+ 1/2)))
(check-tail-exn type-exception? (lambda () (fl+ 1/2 9.0)))
(check-tail-exn type-exception? (lambda () (fl+ 9.0 1/2)))
(check-tail-exn type-exception? (lambda () (fl+ 1/2 3.0 9.0)))
(check-tail-exn type-exception? (lambda () (fl+ 3.0 1/2 9.0)))
(check-tail-exn type-exception? (lambda () (fl+ 3.0 9.0 1/2)))
