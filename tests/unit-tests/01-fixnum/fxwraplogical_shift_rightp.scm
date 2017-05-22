(include "#.scm")

(check-eqv? (##fxwraplogical-shift-right? 0 0) 0)
(check-eqv? (##fxwraplogical-shift-right? -1 1) ##max-fixnum)
(check-eqv? (##fxwraplogical-shift-right? 22 2) 5)
(check-eqv? (##fxwraplogical-shift-right? 33 4) 2)
(check-eqv? (##fxwraplogical-shift-right? 1 ##min-fixnum) #f)
