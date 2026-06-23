(include "#.scm")

(test-eqv 8 (##fxarithmetic-shift-left? 1 3))
(test-eqv 64 (##fxarithmetic-shift-left? 1 6))
(test-eqv 512 (##fxarithmetic-shift-left? 1 9))
(test-eqv
 (##greatest-fixnum)
 (##fxarithmetic-shift-left? (##greatest-fixnum) 0))
(test-eqv #f (##fxarithmetic-shift-left? (##greatest-fixnum) 1))
(test-eqv #f (##fxarithmetic-shift-left? 1 100))
(test-eqv #f (##fxarithmetic-shift-left? 1 -9))
