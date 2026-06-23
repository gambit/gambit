(include "#.scm")

(test-eqv 1 (##fxarithmetic-shift-right? 3 1))
(test-eqv 3 (##fxarithmetic-shift-right? 6 1))
(test-eqv 4 (##fxarithmetic-shift-right? 9 1))
(test-eqv 0 (##fxarithmetic-shift-right? 9 100))
(test-eqv #f (##fxarithmetic-shift-right? 1 -9))
