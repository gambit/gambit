(include "#.scm")

(check-eqv? (##fx* 6 7)   42)
(check-eqv? (##fx* -6 -7)  42)
(check-eqv? (##fx* 6 -7) -42)
(check-eqv? (##fx* -42 0) 0)

(check-eqv? (##fx*) 1)
(check-eqv? (##fx* 2) 2)
(check-eqv? (##fx* 1 2) 2)
(check-eqv? (##fx* 1 2 3) 6)
(check-eqv? (##fx* 1 2 3 4) 24)

(check-eqv? (fx* 6 7)   42)
(check-eqv? (fx* -6 -7)  42)
(check-eqv? (fx* 6 -7) -42)
(check-eqv? (fx* -42 0) 0)

(check-eqv? (fx*) 1)
(check-eqv? (fx* 2) 2)
(check-eqv? (fx* 1 2) 2)
(check-eqv? (fx* 1 2 3) 6)
(check-eqv? (fx* 1 2 3 4) 24)

(check-tail-exn fixnum-overflow-exception? (lambda () (fx* ##max-fixnum 2)))
(check-tail-exn fixnum-overflow-exception? (lambda () (fx* ##min-fixnum 2)))

(check-tail-exn type-exception? (lambda () (fx* 0.5)))
(check-tail-exn type-exception? (lambda () (fx* 0.5 9)))
(check-tail-exn type-exception? (lambda () (fx* 9 0.5)))
(check-tail-exn type-exception? (lambda () (fx* 0.5 3 9)))
(check-tail-exn type-exception? (lambda () (fx* 3 0.5 9)))
(check-tail-exn type-exception? (lambda () (fx* 3 9 0.5)))
