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
(check-eqv? (expt -4 1/4) 1+i)
(check-eqv? (expt -4 3/4) -2+2i)
(check-eqv? (expt -4 5/4) -4-4i)
(check-eqv? (expt -64 1/6) (* 2 (make-rectangular (sqrt 3/4) 1/2)))
(check-eqv? (expt -64 5/6) (* 32 (make-rectangular (- (sqrt 3/4)) 1/2)))
(check-eqv? (expt (expt 1+1/10i 8) 3/8) (expt 1+1/10i 3))
(check-eqv? (expt 8/27 1/3) 2/3)
(check-eqv? (expt -8/27 1/3) 1/3+.5773502691896257i)
(check-eqv? (expt 4.0 1/2) 2.0)
(check-eqv? (expt 4 .5) 2.0)
(check-eqv? (expt 1+i 1/2) (sqrt 1+i))
(check-eqv? (expt -1 (expt 2 10000)) 1)
(check-eqv? (expt -1 (+ 1 (expt 2 10000))) -1)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (expt 'a 2)))
(check-tail-exn type-exception? (lambda () (expt 2 'a)))

