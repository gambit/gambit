(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (imag-part 'a))

