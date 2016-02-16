(include "#.scm")

(check-eqv? (##flinfinite? +inf.0) #t)
(check-eqv? (##flinfinite? -inf.0) #t)
(check-eqv? (##flinfinite? -0.0)   #f)
(check-eqv? (##flinfinite? 0.0)    #f)
(check-eqv? (##flinfinite? 1.5)    #f)
(check-eqv? (##flinfinite? -1.5)   #f)

(check-eqv? (flinfinite? +inf.0) #t)
(check-eqv? (flinfinite? -inf.0) #t)
(check-eqv? (flinfinite? -0.0)   #f)
(check-eqv? (flinfinite? 0.0)    #f)
(check-eqv? (flinfinite? 1.5)    #f)
(check-eqv? (flinfinite? -1.5)   #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flinfinite?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (flinfinite? 1.0 2.0)))

(check-tail-exn type-exception? (lambda () (flinfinite? 1)))
(check-tail-exn type-exception? (lambda () (flinfinite? 1/2)))
