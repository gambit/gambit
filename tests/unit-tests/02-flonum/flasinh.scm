(include "#.scm")

(check-= (flasinh 0.) (flasinh-144 0.))
(check-= (flasinh 0.5) (flasinh-144 0.5))
(check-= (flasinh -0.5) (flasinh-144 -0.5))

(check-tail-exn type-exception? (lambda () (flasinh 0)))
(check-tail-exn type-exception? (lambda () (flasinh 1/2)))
(check-tail-exn type-exception? (lambda () (flasinh 'a)))
