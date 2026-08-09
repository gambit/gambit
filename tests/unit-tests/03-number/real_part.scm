(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (real-part 'a))

