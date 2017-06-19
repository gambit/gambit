(include "#.scm")

(check-= (flatanh 0.) (flatanh-144 0.))
(check-= (flatanh 0.5) (flatanh-144 0.5))
(check-= (flatanh -0.5) (flatanh-144 -0.5))

(check-tail-exn type-exception? (lambda () (flatanh 0)))
(check-tail-exn type-exception? (lambda () (flatanh 1/2)))
(check-tail-exn type-exception? (lambda () (flatanh 'a)))
