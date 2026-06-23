(include "#.scm")

(test-eqv 1 (##fxarithmetic-shift 1 0))
(test-eqv 2 (##fxarithmetic-shift 1 1))
(test-eqv 8 (##fxarithmetic-shift 1 3))
(test-eqv 16 (##fxarithmetic-shift 1 4))

(test-eqv 1 (fxarithmetic-shift 1 0))
(test-eqv 2 (fxarithmetic-shift 1 1))
(test-eqv 8 (fxarithmetic-shift 1 3))
(test-eqv 16 (fxarithmetic-shift 1 4))

(test-error-tail type-exception? (fxarithmetic-shift 0. 1))
(test-error-tail type-exception? (fxarithmetic-shift .5 1))
(test-error-tail type-exception? (fxarithmetic-shift 1 .5))
(test-error-tail type-exception? (fxarithmetic-shift 1 1/2))

(test-error-tail
 fixnum-overflow-exception?
 (fxarithmetic-shift (##least-fixnum) 1))
(test-error-tail
 fixnum-overflow-exception?
 (fxarithmetic-shift (##greatest-fixnum) 1))

(test-error-tail wrong-number-of-arguments-exception? (fxarithmetic-shift))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxarithmetic-shift 1 1 1))
