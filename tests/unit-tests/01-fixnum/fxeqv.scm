(include "#.scm")

(check-eqv? (##fxeqv) -1)
(check-eqv? (##fxeqv 1) 1)
(check-eqv? (##fxeqv 85 204 240) 105)
(check-eqv? (##fxeqv ##min-fixnum ##max-fixnum) 0)

(check-eqv? (fxeqv) -1)
(check-eqv? (fxeqv 1) 1)
(check-eqv? (fxeqv 85 204 240) 105)
(check-eqv? (fxeqv ##min-fixnum ##max-fixnum) 0)

(check-tail-exn type-exception? (lambda () (fxeqv 0.0)))
(check-tail-exn type-exception? (lambda () (fxeqv 0.5)))
(check-tail-exn type-exception? (lambda () (fxeqv 1/2)))
