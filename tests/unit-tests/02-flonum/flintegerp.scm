(include "#.scm")

(check-eqv? (##flinteger? +inf.0) #f)
(check-eqv? (##flinteger? -inf.0) #f)
(check-eqv? (##flinteger? -0.0)   #t)
(check-eqv? (##flinteger? 0.0)    #t)
(check-eqv? (##flinteger? 1.5)    #f)
(check-eqv? (##flinteger? -1.5)   #f)

(check-eqv? (flinteger? +inf.0) #f)
(check-eqv? (flinteger? -inf.0) #f)
(check-eqv? (flinteger? -0.0)   #t)
(check-eqv? (flinteger? 0.0)    #t)
(check-eqv? (flinteger? 1.5)    #f)
(check-eqv? (flinteger? -1.5)   #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flinteger?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flinteger? 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flinteger? 1)))
(check-tail-exn type-exception? (lambda () (flinteger? 1/2)))
