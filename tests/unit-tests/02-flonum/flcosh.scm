(include "#.scm")

(check-= (flcosh 0.) (flcosh-144 0.))
(check-= (flcosh 0.5) (flcosh-144 0.5))
(check-= (flcosh -0.5) (flcosh-144 -0.5))

(check-tail-exn type-exception? (lambda () (flcosh 0)))
(check-tail-exn type-exception? (lambda () (flcosh 1/2)))
(check-tail-exn type-exception? (lambda () (flcosh 'a)))
