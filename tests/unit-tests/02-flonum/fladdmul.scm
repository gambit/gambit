(include "#.scm")

(test-approximate -1.1102230246251565e-16 (##fl+* -0.4 3.0 1.2) 1e-12)
(test-approximate 1.0 (##fl+* -268435455.0 268435457.0 7.205759403792794e16) 1e-12)

(test-approximate -1.1102230246251565e-16 (fl+* -0.4 3.0 1.2) 1e-12)
(test-approximate 1.0 (fl+* -268435455.0 268435457.0 7.205759403792794e16) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (fl+* 123))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 123 9.0))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 9.0 123))

(test-error-tail type-exception? (fl+* 123 3.0 9.0))
(test-error-tail type-exception? (fl+* 3.0 123 9.0))
(test-error-tail type-exception? (fl+* 3.0 9.0 123))
