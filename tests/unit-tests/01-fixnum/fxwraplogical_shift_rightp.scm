(include "#.scm")

(test-eqv 0 (##fxwraplogical-shift-right? 0 0))
(test-eqv (##greatest-fixnum) (##fxwraplogical-shift-right? -1 1))
(test-eqv 5 (##fxwraplogical-shift-right? 22 2))
(test-eqv 2 (##fxwraplogical-shift-right? 33 4))
(test-eqv #f (##fxwraplogical-shift-right? 1 (##least-fixnum)))
