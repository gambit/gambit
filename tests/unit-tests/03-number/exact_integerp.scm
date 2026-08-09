(include "#.scm")

(test-assert (eq? #f (exact-integer? 123.)))
(test-assert (eq? #f (exact-integer? .5)))
(test-assert (eq? #t (exact-integer? 123)))
(test-assert (eq? #t (exact-integer? 100000000000000000000)))
(test-assert (eq? #f (exact-integer? 1/2)))
(test-assert (eq? #f (exact-integer? 1/2+3/4i)))
(test-assert (eq? #f (exact-integer? 123+0.i)))

;;; Test exceptions

(test-error-tail wrong-number-of-arguments-exception? (exact-integer?))
(test-error-tail wrong-number-of-arguments-exception? (exact-integer? 0 0))
