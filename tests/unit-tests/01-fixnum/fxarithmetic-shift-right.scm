(include "#.scm")

(check-eqv? (##fxarithmetic-shift-right 3 1) 1)
(check-eqv? (##fxarithmetic-shift-right 6 1) 3)
(check-eqv? (##fxarithmetic-shift-right 9 1) 4)

(check-eqv? (fxarithmetic-shift-right 3 1) 1)
(check-eqv? (fxarithmetic-shift-right 6 1) 3)
(check-eqv? (fxarithmetic-shift-right 9 1) 4)

(check-tail-exn range-exception? (lambda () (fxarithmetic-shift-right 1 -9)))

(check-tail-exn type-exception? (lambda () (fxarithmetic-shift-right 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift-right 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift-right 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift-right 1 1/2)))
