(include "#.scm")

(check-eqv? (##fxzero? 0)   #t)
(check-eqv? (##fxzero? 1)   #f)

(check-eqv? (fxzero? 0)   #t)
(check-eqv? (fxzero? 1)   #f)

(check-tail-exn type-exception? (lambda () (fxzero? 0.0)))
(check-tail-exn type-exception? (lambda () (fxzero? 0.5)))
(check-tail-exn type-exception? (lambda () (fxzero? 1/3)))
