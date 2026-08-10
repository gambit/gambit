(include "#.scm")

;; Here we assume IEEE double precision arithmetic rounding to nearest.

(test-eqv -1.1102230246251565e-16 (##fl+* -0.4 3.0 1.2))
(test-eqv 1.0 (##fl+* -268435455.0 268435457.0 7.205759403792794e16))

(test-eqv -1.1102230246251565e-16 (fl+* -0.4 3.0 1.2))
(test-eqv 1.0 (fl+* -268435455.0 268435457.0 7.205759403792794e16))

(test-eqv -0. (fl+* -1. +0. -0.))
(test-eqv +0. (fl+* +1. +0. -0.))

(test-eqv -0. (##fl+* -1. +0. -0.))
(test-eqv +0. (##fl+* +1. +0. -0.))

(test-error-tail wrong-number-of-arguments-exception? (fl+* 1.0))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 1.0 2.0))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 1.0 2.0 3.0 4.0))

(test-error-tail type-exception? (fl+* 123 3.0 9.0))
(test-error-tail type-exception? (fl+* 3.0 123 9.0))
(test-error-tail type-exception? (fl+* 3.0 9.0 123))
