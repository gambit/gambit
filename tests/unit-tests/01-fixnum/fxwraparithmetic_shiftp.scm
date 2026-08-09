(include "#.scm")

(test-eqv 32 (##fxwraparithmetic-shift? 1 5))
(test-eqv 8 (##fxwraparithmetic-shift? 1 3))
(test-eqv 512 (##fxwraparithmetic-shift? 1 9))
(test-eqv -18 (##fxwraparithmetic-shift? -9 1))
(test-eqv -10 (##fxwraparithmetic-shift? -5 1))
(test-eqv -6 (##fxwraparithmetic-shift? -3 1))

(test-eqv 5 (##fxwraparithmetic-shift? 10 -1))
(test-eqv 0 (##fxwraparithmetic-shift? 1 -1))

(test-eqv #f (##fxwraparithmetic-shift? 1 (+ (##fixnum-width) 1)))
(test-eqv #f (##fxwraparithmetic-shift? 1 (- (+ (##fixnum-width) 1))))
