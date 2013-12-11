(include "#.scm")

(check-eqv? (fx+ 11 33)   44)
(check-eqv? (fx+ 11 -11)   0)
(check-eqv? (fx+ 11 -33) -22)
(check-eqv? (fx+ -11 33)  22)

(check-eqv? (fx+) 0)
(check-eqv? (fx+ 11) 11)
(check-eqv? (fx+ 11 22) 33)
(check-eqv? (fx+ 11 22 33) 66)
(check-eqv? (fx+ 11 22 33 44) 110)

(check-exn type-exception? (lambda () (fx+ 1/2)))
(check-exn type-exception? (lambda () (fx+ 1/2 9)))
(check-exn type-exception? (lambda () (fx+ 9 1/2)))
(check-exn type-exception? (lambda () (fx+ 1/2 3 9)))
(check-exn type-exception? (lambda () (fx+ 3 1/2 9)))
(check-exn type-exception? (lambda () (fx+ 3 9 1/2)))

(check-exn fixnum-overflow-exception? (lambda () (fx+ ##max-fixnum 1)))
(check-exn fixnum-overflow-exception? (lambda () (fx+ ##min-fixnum -1)))
