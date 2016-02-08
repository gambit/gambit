(include "#.scm")

(check-eqv? (##fxfirst-bit-set 1) 0)
(check-eqv? (##fxfirst-bit-set 100) 2)
(check-eqv? (##fxfirst-bit-set -1000) 3)

(check-eqv? (fxfirst-bit-set 1) 0)
(check-eqv? (fxfirst-bit-set 100) 2)
(check-eqv? (fxfirst-bit-set -1000) 3)

(check-tail-exn type-exception? (lambda () (fxfirst-bit-set 0.5)))
(check-tail-exn type-exception? (lambda () (fxfirst-bit-set 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxfirst-bit-set)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxfirst-bit-set 1 1)))
