(include "#.scm")

(test-eqv 0 (##fxwraparithmetic-shift-left? 0 0))
(test-eqv 2 (##fxwraparithmetic-shift-left? 1 1))
(test-eqv -24 (##fxwraparithmetic-shift-left? -3 3))
(test-eqv -160 (##fxwraparithmetic-shift-left? -5 5))


(test-eqv #f (##fxwraparithmetic-shift-left? 1 -1))
(test-eqv 0 (##fxwraparithmetic-shift-left? 1 (##fixnum-width)))
(test-eqv #f (##fxwraparithmetic-shift-left? 1 (+ (##fixnum-width) 1)))

(test-eqv
 (##greatest-fixnum)
 (##fxwraparithmetic-shift-left? (##greatest-fixnum) 0))
(test-eqv -2 (##fxwraparithmetic-shift-left? (##greatest-fixnum) 1))
