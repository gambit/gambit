(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (make-polar 'a 2))
(test-error-tail type-exception? (make-polar 2 'a))
(test-error-tail type-exception? (make-polar 2 +i))
(test-error-tail type-exception? (make-polar +i 2))

