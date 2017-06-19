(include "#.scm")

(check-= (flsinh 0.) (flsinh-144 0.))
(check-= (flsinh 0.5) (flsinh-144 0.5))
(check-= (flsinh -0.5) (flsinh-144 -0.5))

(check-tail-exn type-exception? (lambda () (flsinh 0)))
(check-tail-exn type-exception? (lambda () (flsinh 1/2)))
(check-tail-exn type-exception? (lambda () (flsinh 'a)))
