(include "#.scm")

(check-eqv? (##flnegative? -inf.0) #t)
(check-eqv? (##flnegative? +inf.0) #f)
(check-eqv? (##flnegative? 0.0) #f)
(check-eqv? (##flnegative? -0.0) #f)
(check-eqv? (##flnegative? -1.0) #t)
(check-eqv? (##flnegative? 1.0) #f)

(check-eqv? (flnegative? -inf.0) #t)
(check-eqv? (flnegative? +inf.0) #f)
(check-eqv? (flnegative? 0.0) #f)
(check-eqv? (flnegative? -0.0) #f)
(check-eqv? (flnegative? -1.0) #t)
(check-eqv? (flnegative? 1.0) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flnegative?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flnegative? 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flnegative? 1)))
(check-tail-exn type-exception? (lambda () (flnegative? 1/2)))
