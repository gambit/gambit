(include "#.scm")

;;; Test values

(check-eqv? (expt 2 3) 8)
(check-eqv? (expt 2 -3) 1/8)
(check-eqv? (expt 8 1/3) 2)
(check-eqv? (expt 1+i 2) +2i)
(check-eqv? (expt +2i 1/2) 1+i)
(check-eqv? (expt +2i 3/2) -2+2i)
(check-eqv? (expt -2i 1/2) 1-i)
(check-eqv? (expt -2i 3/2) -2-2i)
(check-eqv? (expt 8/27 1/3) 2/3)
(check-eqv? (expt -8/27 1/3) 1/3+.5773502691896257i)
(check-eqv? (expt 4.0 1/2) 2.0)
(check-eqv? (expt 4 .5) 2.0)
(check-eqv? (expt 1+i 1/2) (sqrt 1+i))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (expt 'a 2)))
(check-tail-exn type-exception? (lambda () (expt 2 'a)))

