(include "#.scm")

;;; Test special values

(check-eqv? (tanh 0) 0)
(check-eqv? (tanh 1) (imag-part (tan +i)))

;;; Test for accuracy near 0

(check-eqv? (tanh 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (tanh 'a)))

