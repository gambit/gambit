(include "#.scm")

;;; Test branch cuts

(check-eqv? (sqrt -1) +i)
(check-= (sqrt -1+0.i) +i)
(check-= (sqrt -1-0.i) -i)

;;; Test some exact values

(check-eqv? (sqrt -1) +i)
(check-eqv? (sqrt +2i) 1+i)
(check-eqv? (sqrt -2i) 1-i)
