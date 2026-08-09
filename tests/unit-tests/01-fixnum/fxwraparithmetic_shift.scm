(include "#.scm")

(test-eqv 32 (##fxwraparithmetic-shift 1 5))
(test-eqv 8 (##fxwraparithmetic-shift 1 3))
(test-eqv 512 (##fxwraparithmetic-shift 1 9))
(test-eqv -18 (##fxwraparithmetic-shift -9 1))
(test-eqv -10 (##fxwraparithmetic-shift -5 1))
(test-eqv -6 (##fxwraparithmetic-shift -3 1))

(test-eqv 32 (fxwraparithmetic-shift 1 5))
(test-eqv 8 (fxwraparithmetic-shift 1 3))
(test-eqv 512 (fxwraparithmetic-shift 1 9))
(test-eqv -18 (fxwraparithmetic-shift -9 1))
(test-eqv -10 (fxwraparithmetic-shift -5 1))
(test-eqv -6 (fxwraparithmetic-shift -3 1))

(test-error-tail range-exception? (fxwraparithmetic-shift 1 (##least-fixnum)))

(test-error-tail wrong-number-of-arguments-exception? (fxwraparithmetic-shift))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraparithmetic-shift 1 1 1))

(test-error-tail type-exception? (fxwraparithmetic-shift 1 0.))
(test-error-tail type-exception? (fxwraparithmetic-shift 1 .5))
(test-error-tail type-exception? (fxwraparithmetic-shift .5 1))
(test-error-tail type-exception? (fxwraparithmetic-shift 1 1/2))
