(include "#.scm")

(test-equal 123. (exact->inexact 123.))
(test-equal .5 (exact->inexact .5))
(test-equal 123. (exact->inexact 123))
(test-equal .5 (exact->inexact 1/2))
(test-equal .5+.75i (exact->inexact 1/2+3/4i))

;;; Test exceptions

(test-error-tail type-exception? (exact->inexact 'a))

