(include "#.scm")

(check-eqv? (##flzero? 0.0) #t)
(check-eqv? (##flzero? -0.0) #t)
(check-eqv? (##flzero? 1.5) #f)
(check-eqv? (##flzero? -1.5) #f)
(check-eqv? (##flzero? +inf.0) #f)
(check-eqv? (##flzero? -inf.0) #f)

(check-eqv? (flzero? 0.0) #t)
(check-eqv? (flzero? -0.0) #t)
(check-eqv? (flzero? 1.5) #f)
(check-eqv? (flzero? -1.5) #f)
(check-eqv? (flzero? +inf.0) #f)
(check-eqv? (flzero? -inf.0) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flzero?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flzero? 1.0 0.5)))

(check-tail-exn type-exception? (lambda () (flzero? 1/2)))
(check-tail-exn type-exception? (lambda () (flzero? 0)))
