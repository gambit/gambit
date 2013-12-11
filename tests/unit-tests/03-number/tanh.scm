(include "#.scm")

;;; Test special values

(check-eqv? (tanh 0) 0)

;;; Test for accuracy near 0

(check-eqv? (tanh 1e-30+1e-40i) 1e-30+1e-40i)
