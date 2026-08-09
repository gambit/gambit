(include "#.scm")

;;; Test special values

(test-eqv 1 (cos 0))

;;; Test exceptions

(test-error-tail type-exception? (cos 'a))

