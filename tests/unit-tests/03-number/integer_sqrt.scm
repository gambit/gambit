(include "#.scm")

(test-eqv 0 (integer-sqrt 0))
(test-eqv 31 (integer-sqrt 1000))
(test-eqv 31622776601 (integer-sqrt 1000000000000000000000))

;;; Test exceptions

(test-error-tail type-exception? (integer-sqrt #f))

(test-error-tail range-exception? (integer-sqrt -1))

(test-error-tail wrong-number-of-arguments-exception? (integer-sqrt))
(test-error-tail wrong-number-of-arguments-exception? (integer-sqrt 0 0))
