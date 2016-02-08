(include "#.scm")

(check-eqv? (##fxpositive? ##max-fixnum) #t)
(check-eqv? (##fxpositive? ##min-fixnum) #f)

(check-eqv? (fxpositive? ##max-fixnum) #t)
(check-eqv? (fxpositive? ##min-fixnum) #f)

(check-tail-exn type-exception? (lambda () (fxpositive? 0.5)))
(check-tail-exn type-exception? (lambda () (fxpositive? 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxpositive?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxpositive? 2 -4)))
