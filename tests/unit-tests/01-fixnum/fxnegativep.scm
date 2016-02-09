(include "#.scm")

(check-eqv? (##fxnegative? ##min-fixnum) #t)
(check-eqv? (##fxnegative? ##max-fixnum) #f)

(check-eqv? (fxnegative? ##min-fixnum) #t)
(check-eqv? (fxnegative? ##max-fixnum) #f)

(check-tail-exn type-exception? (lambda () (fxnegative? 0.0)))
(check-tail-exn type-exception? (lambda () (fxnegative? 0.5)))
(check-tail-exn type-exception? (lambda () (fxnegative? 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxnegative?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxnegative? 2 -4)))
