(include "#.scm")

(test-equal 123 (exact 123))
(test-equal 1/2 (exact 1/2))
(test-equal 123 (exact 123.))
(test-equal 1/2 (exact .5))
(test-equal 1/2+3/4i (exact .5+.75i))

;;; Test exceptions

(test-error-tail type-exception? (exact 'a))

