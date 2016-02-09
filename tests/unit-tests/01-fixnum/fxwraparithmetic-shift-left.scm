(include "#.scm")

(check-eqv? (##fxwraparithmetic-shift-left 0 0) 0)
(check-eqv? (##fxwraparithmetic-shift-left 1 1) 2)
(check-eqv? (##fxwraparithmetic-shift-left -3 3) -24)
(check-eqv? (##fxwraparithmetic-shift-left -5 5) -160)

(check-eqv? (fxwraparithmetic-shift-left 0 0) 0)
(check-eqv? (fxwraparithmetic-shift-left 1 1) 2)
(check-eqv? (fxwraparithmetic-shift-left -3 3) -24)
(check-eqv? (fxwraparithmetic-shift-left -5 5) -160)

(check-tail-exn range-exception? (lambda () (fxwraparithmetic-shift-left 1 ##max-fixnum)))

(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift-left 1 0.0)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift-left 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift-left 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxwraparithmetic-shift-left 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraparithmetic-shift-left)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraparithmetic-shift-left 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraparithmetic-shift-left 1 2 3)))
