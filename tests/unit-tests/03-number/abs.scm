(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (abs #\c))
(test-error-tail type-exception? (abs +i))

