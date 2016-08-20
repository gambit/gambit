(include "#.scm")

(check-eqv? (##fxarithmetic-shift-right? 3 1) 1)
(check-eqv? (##fxarithmetic-shift-right? 6 1) 3)
(check-eqv? (##fxarithmetic-shift-right? 9 1) 4)
(check-eqv? (##fxarithmetic-shift-right? 9 100) 0)
(check-eqv? (##fxarithmetic-shift-right? 1 -9) #f)
