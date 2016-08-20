(include "#.scm")

(check-eqv? (##fxarithmetic-shift-left? 1 3) 8)
(check-eqv? (##fxarithmetic-shift-left? 1 6) 64)
(check-eqv? (##fxarithmetic-shift-left? 1 9) 512)
(check-eqv? (##fxarithmetic-shift-left? ##max-fixnum 0) ##max-fixnum)
(check-eqv? (##fxarithmetic-shift-left? ##max-fixnum 1) #f)
(check-eqv? (##fxarithmetic-shift-left? 1 100) #f)
(check-eqv? (##fxarithmetic-shift-left? 1 -9) #f)
