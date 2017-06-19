(include "#.scm")

(check-= (flacosh 1.) (flacosh-144 1.))
(check-= (flacosh 1.5) (flacosh-144 1.5))

(check-tail-exn type-exception? (lambda () (flacosh 1)))
(check-tail-exn type-exception? (lambda () (flacosh 1/2)))
(check-tail-exn type-exception? (lambda () (flacosh 'a)))
