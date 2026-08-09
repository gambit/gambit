(include "#.scm")

(test-equal 123 (inexact->exact 123))
(test-equal 1/2 (inexact->exact 1/2))
(test-equal 123 (inexact->exact 123.))
(test-equal 1/2 (inexact->exact .5))
(test-equal 1/2+3/4i (inexact->exact .5+.75i))

;;; Test exceptions

(test-error-tail type-exception? (inexact->exact 'a))

