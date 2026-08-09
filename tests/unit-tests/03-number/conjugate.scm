(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (conjugate 'a))

