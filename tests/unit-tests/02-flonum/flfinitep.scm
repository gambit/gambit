(include "#.scm")

(check-eqv? (##flfinite? +inf.0) #f)
(check-eqv? (##flfinite? -inf.0) #f)
(check-eqv? (##flfinite? -0.0)   #t)
(check-eqv? (##flfinite? 0.0)    #t)
(check-eqv? (##flfinite? 1.5)    #t)
(check-eqv? (##flfinite? -1.5)   #t)

(check-eqv? (flfinite? +inf.0) #f)
(check-eqv? (flfinite? -inf.0) #f)
(check-eqv? (flfinite? -0.0)   #t)
(check-eqv? (flfinite? 0.0)    #t)
(check-eqv? (flfinite? 1.5)    #t)
(check-eqv? (flfinite? -1.5)   #t)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flfinite?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flfinite? 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flfinite? 1)))
(check-tail-exn type-exception? (lambda () (flfinite? 1/2)))
