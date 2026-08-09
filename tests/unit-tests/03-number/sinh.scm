(include "#.scm")

;;; Test special values

(test-eqv 0 (sinh 0))
(test-eqv (imag-part (sin +i)) (sinh 1))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (sinh 1e-30+1e-40i))

;;; Test exceptions

(test-error-tail type-exception? (asinh 'a))

