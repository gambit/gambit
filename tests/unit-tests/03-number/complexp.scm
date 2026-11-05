(include "#.scm")

(test-assert (complex? 1))
(test-assert (complex? 10000000000000000000000000000))
(test-assert (complex? 2/3))
(test-assert (complex? 1.0))
(test-assert (complex? 1+1.0i))
(test-assert (not (complex? 'a)))
(test-assert (not (complex? #\c)))
(test-assert (not (complex? "a")))

;;; Test exceptions

(test-error-tail wrong-number-of-arguments-exception? (complex?))
(test-error-tail wrong-number-of-arguments-exception? (complex? 0 0))
