(include "#.scm")

(receive (a b) (exact-integer-sqrt 0)
  (check-eqv? a 0)
  (check-eqv? b 0))

(receive (a b) (exact-integer-sqrt 1000)
  (check-eqv? a 31)
  (check-eqv? b 39))

(receive (a b) (exact-integer-sqrt 1000000000000000000000)
  (check-eqv? a 31622776601)
  (check-eqv? b 43246886799))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (exact-integer-sqrt #f)))

(check-tail-exn range-exception? (lambda () (exact-integer-sqrt -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (exact-integer-sqrt)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (exact-integer-sqrt 0 0)))
