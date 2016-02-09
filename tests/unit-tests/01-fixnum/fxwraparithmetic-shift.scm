(include "#.scm")

(check-eqv? (##fxwraparithmetic-shift 1 5) 32)
(check-eqv? (##fxwraparithmetic-shift 1 3) 8)
(check-eqv? (##fxwraparithmetic-shift 1 9) 512)
(check-eqv? (##fxwraparithmetic-shift -9 1) -18)
(check-eqv? (##fxwraparithmetic-shift -5 1) -10)
(check-eqv? (##fxwraparithmetic-shift -3 1) -6)

(check-eqv? (fxwraparithmetic-shift 1 5) 32)
(check-eqv? (fxwraparithmetic-shift 1 3) 8)
(check-eqv? (fxwraparithmetic-shift 1 9) 512)
(check-eqv? (fxwraparithmetic-shift -9 1) -18)
(check-eqv? (fxwraparithmetic-shift -5 1) -10)
(check-eqv? (fxwraparithmetic-shift -3 1) -6)

(check-tail-exn range-exception? (lambda () (fxwraparithmetic-shift 1 ##min-fixnum)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraparithmetic-shift)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraparithmetic-shift 1 1 1)))

(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift 1 0.0)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift 1 1/2)))
