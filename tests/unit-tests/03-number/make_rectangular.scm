(include "#.scm")

;;; Test exceptions

(test-error-tail type-exception? (make-rectangular 'a 2))
(test-error-tail type-exception? (make-rectangular 2 'a))
(test-error-tail type-exception? (make-rectangular 2 +i))
(test-error-tail type-exception? (make-rectangular +i 2))

