(include "#.scm")

(check-= (fltanh 0.) (fltanh-144 0.))
(check-= (fltanh 0.5) (fltanh-144 0.5))
(check-= (fltanh -0.5) (fltanh-144 -0.5))

(check-tail-exn type-exception? (lambda () (fltanh 0)))
(check-tail-exn type-exception? (lambda () (fltanh 1/2)))
(check-tail-exn type-exception? (lambda () (fltanh 'a)))
