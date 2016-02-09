(include "#.scm")

(check-eqv? (##fx>=) #t)
(check-eqv? (##fx>= 1) #t)
(check-eqv? (##fx>= ##min-fixnum ##max-fixnum) #f)
(check-eqv? (##fx>= ##max-fixnum ##min-fixnum) #t)
(check-eqv? (##fx>= ##max-fixnum ##max-fixnum) #t)

(check-eqv? (fx>=) #t)
(check-eqv? (fx>= 1) #t)
(check-eqv? (fx>= ##min-fixnum ##max-fixnum) #f)
(check-eqv? (fx>= ##max-fixnum ##min-fixnum) #t)
(check-eqv? (fx>= ##max-fixnum ##max-fixnum) #t)

(check-tail-exn type-exception? (lambda () (fx>= 0.0 1)))
(check-tail-exn type-exception? (lambda () (fx>= 0.5 1)))
(check-tail-exn type-exception? (lambda () (fx>= 1 0.5)))
(check-tail-exn type-exception? (lambda () (fx>= 1/3 1)))
