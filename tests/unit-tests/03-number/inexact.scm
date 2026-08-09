(include "#.scm")

(test-equal 123. (inexact 123.))
(test-equal .5 (inexact .5))
(test-equal 123. (inexact 123))
(test-equal .5 (inexact 1/2))
(test-equal .5+.75i (inexact 1/2+3/4i))

;;; Test exceptions

(test-error-tail type-exception? (inexact 'a))

