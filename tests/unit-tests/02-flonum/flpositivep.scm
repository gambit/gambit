(include "#.scm")

(check-eqv? (##flpositive? +inf.0) #t)
(check-eqv? (##flpositive? -inf.0) #f)
(check-eqv? (##flpositive? -0.0) #f)
(check-eqv? (##flpositive? 0.0) #f)
(check-eqv? (##flpositive? 1.0) #t)
(check-eqv? (##flpositive? -1.0) #f)

(check-eqv? (flpositive? +inf.0) #t)
(check-eqv? (flpositive? -inf.0) #f)
(check-eqv? (flpositive? -0.0) #f)
(check-eqv? (flpositive? 0.0) #f)
(check-eqv? (flpositive? 1.0) #t)
(check-eqv? (flpositive? -1.0) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flpositive?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flpositive? 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flpositive? 1)))
(check-tail-exn type-exception? (lambda () (flpositive? 1/2)))
