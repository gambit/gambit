(include "#.scm")

(test-assert (not (inexact? 1)))
(test-assert (not (inexact? 10000000000000000000000000000)))
(test-assert (not (inexact? 2/3)))
(test-assert (inexact? 1.0))
(test-assert (inexact? 1+1.0i))

;;; Test exceptions

(test-error-tail type-exception? (inexact? #\c))
(test-error-tail type-exception? (inexact? 'a))
(test-error-tail type-exception? (inexact? "a"))


(test-error-tail wrong-number-of-arguments-exception? (inexact?))
(test-error-tail wrong-number-of-arguments-exception? (inexact? 0 0))

