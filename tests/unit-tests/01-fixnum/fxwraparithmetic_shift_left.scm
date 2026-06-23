(include "#.scm")

(test-eqv 0 (##fxwraparithmetic-shift-left 0 0))
(test-eqv 2 (##fxwraparithmetic-shift-left 1 1))
(test-eqv -24 (##fxwraparithmetic-shift-left -3 3))
(test-eqv -160 (##fxwraparithmetic-shift-left -5 5))
(test-eqv
 (##greatest-fixnum)
 (##fxwraparithmetic-shift-left (##greatest-fixnum) 0))

(test-eqv 0 (fxwraparithmetic-shift-left 0 0))
(test-eqv 2 (fxwraparithmetic-shift-left 1 1))
(test-eqv -24 (fxwraparithmetic-shift-left -3 3))
(test-eqv -160 (fxwraparithmetic-shift-left -5 5))
(test-eqv
 (##greatest-fixnum)
 (fxwraparithmetic-shift-left (##greatest-fixnum) 0))

(test-error-tail
 range-exception?
 (fxwraparithmetic-shift-left 1 (##greatest-fixnum)))

(test-error-tail type-exception? (fxwraparithmetic-shift-left 1 0.))
(test-error-tail type-exception? (fxwraparithmetic-shift-left .5 1))
(test-error-tail type-exception? (fxwraparithmetic-shift-left 1 .5))
(test-error-tail type-exception? (fxwraparithmetic-shift-left 1 1/2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraparithmetic-shift-left))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraparithmetic-shift-left 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraparithmetic-shift-left 1 2 3))
