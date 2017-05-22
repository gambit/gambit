(include "#.scm")

(check-eqv? (##fxwraparithmetic-shift-left? 0 0) 0)
(check-eqv? (##fxwraparithmetic-shift-left? 1 1) 2)
(check-eqv? (##fxwraparithmetic-shift-left? -3 3) -24)
(check-eqv? (##fxwraparithmetic-shift-left? -5 5) -160)


(check-eqv? (##fxwraparithmetic-shift-left? 1 -1) #f)
(check-eqv? (##fxwraparithmetic-shift-left? 1 ##fixnum-width) 0)
(check-eqv? (##fxwraparithmetic-shift-left? 1 (+ ##fixnum-width 1)) #f)

(check-eqv? (##fxwraparithmetic-shift-left? ##max-fixnum 0) ##max-fixnum)
(check-eqv? (##fxwraparithmetic-shift-left? ##max-fixnum 1) -2)
