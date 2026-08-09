(include "#.scm")

(test-eqv 8 (##fxarithmetic-shift-left 1 3))
(test-eqv 64 (##fxarithmetic-shift-left 1 6))
(test-eqv 512 (##fxarithmetic-shift-left 1 9))
(test-eqv
 (##greatest-fixnum)
 (##fxarithmetic-shift-left (##greatest-fixnum) 0))

(test-eqv 8 (fxarithmetic-shift-left 1 3))
(test-eqv 64 (fxarithmetic-shift-left 1 6))
(test-eqv 512 (fxarithmetic-shift-left 1 9))
(test-eqv (##greatest-fixnum) (fxarithmetic-shift-left (##greatest-fixnum) 0))

(test-error-tail fixnum-overflow-exception? (fxarithmetic-shift-left 1 100))
(test-error-tail
 fixnum-overflow-exception?
 (fxarithmetic-shift-left (##greatest-fixnum) 1))

(test-error-tail range-exception? (fxarithmetic-shift-left 1 -9))

(test-error-tail type-exception? (fxarithmetic-shift-left 0. 1))
(test-error-tail type-exception? (fxarithmetic-shift-left .5 1))
(test-error-tail type-exception? (fxarithmetic-shift-left 1 .5))
(test-error-tail type-exception? (fxarithmetic-shift-left 1 1/2))
