(include "#.scm")

;;; Test special values

(check-eqv? (sinh 0) 0)
(check-eqv? (sinh 1) (imag-part (sin +i)))

;;; Test for accuracy near 0

(check-eqv? (sinh 1e-30+1e-40i) 1e-30+1e-40i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (asinh 'a)))

