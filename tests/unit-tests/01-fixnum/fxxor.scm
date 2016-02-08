(include "#.scm")

(check-eqv? (##fxxor) 0)
(check-eqv? (##fxxor 1) 1)
(check-eqv? (##fxxor 33 22 -11) -62)
(check-eqv? (##fxxor ##min-fixnum ##max-fixnum) -1)

(check-eqv? (fxxor) 0)
(check-eqv? (fxxor 1) 1)
(check-eqv? (fxxor 33 22 -11) -62)
(check-eqv? (fxxor ##min-fixnum ##max-fixnum) -1)

(check-tail-exn type-exception? (lambda () (fxxor 0.5)))
(check-tail-exn type-exception? (lambda () (fxxor 1/2)))
