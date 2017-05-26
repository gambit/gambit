(include "#.scm")

(check-eqv? (##fxwraparithmetic-shift? 1 5) 32)
(check-eqv? (##fxwraparithmetic-shift? 1 3) 8)
(check-eqv? (##fxwraparithmetic-shift? 1 9) 512)
(check-eqv? (##fxwraparithmetic-shift? -9 1) -18)
(check-eqv? (##fxwraparithmetic-shift? -5 1) -10)
(check-eqv? (##fxwraparithmetic-shift? -3 1) -6)

(check-eqv? (##fxwraparithmetic-shift? 10 -1) 5)
(check-eqv? (##fxwraparithmetic-shift? 1 -1) 0)

(check-eqv? (##fxwraparithmetic-shift? 1 (+ ##fixnum-width 1)) #f)
(check-eqv? (##fxwraparithmetic-shift? 1 (- (+ ##fixnum-width 1))) #f)
