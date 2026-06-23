(include "#.scm")

;;; Test special values

(test-eqv 0 (sin 0))

;;; Test for accuracy near 0

(test-eqv 1e-30+1e-40i (sin 1e-30+1e-40i))

;;; Test exceptions

(test-error-tail type-exception? (sin 'a))

