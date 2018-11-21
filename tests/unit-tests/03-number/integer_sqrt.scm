(include "#.scm")

(check-eqv? (integer-sqrt 0) 0)
(check-eqv? (integer-sqrt 1000) 31)
(check-eqv? (integer-sqrt 1000000000000000000000) 31622776601)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (integer-sqrt #f)))

(check-tail-exn range-exception? (lambda () (integer-sqrt -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (integer-sqrt)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (integer-sqrt 0 0)))
