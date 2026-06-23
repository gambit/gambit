(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (exp #\c))

