(include "#.scm")

(test-eqv 1 (##fxarithmetic-shift-right 3 1))
(test-eqv 3 (##fxarithmetic-shift-right 6 1))
(test-eqv 4 (##fxarithmetic-shift-right 9 1))
(test-eqv 0 (##fxarithmetic-shift-right 9 100))

(test-eqv 1 (fxarithmetic-shift-right 3 1))
(test-eqv 3 (fxarithmetic-shift-right 6 1))
(test-eqv 4 (fxarithmetic-shift-right 9 1))
(test-eqv 0 (fxarithmetic-shift-right 9 100))

(test-error-tail range-exception? (fxarithmetic-shift-right 1 -9))

(test-error-tail type-exception? (fxarithmetic-shift-right 0. 1))
(test-error-tail type-exception? (fxarithmetic-shift-right .5 1))
(test-error-tail type-exception? (fxarithmetic-shift-right 1 .5))
(test-error-tail type-exception? (fxarithmetic-shift-right 1 1/2))
