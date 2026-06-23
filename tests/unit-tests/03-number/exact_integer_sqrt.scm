(include "#.scm")

(receive (a b) (exact-integer-sqrt 0) (test-eqv 0 a) (test-eqv 0 b))

(receive (a b) (exact-integer-sqrt 1000) (test-eqv 31 a) (test-eqv 39 b))

(receive (a b)
         (exact-integer-sqrt 1000000000000000000000)
         (test-eqv 31622776601 a)
         (test-eqv 43246886799 b))

;;; Test exceptions

(test-error-tail type-exception? (exact-integer-sqrt #f))

(test-error-tail range-exception? (exact-integer-sqrt -1))

(test-error-tail wrong-number-of-arguments-exception? (exact-integer-sqrt))
(test-error-tail wrong-number-of-arguments-exception? (exact-integer-sqrt 0 0))
