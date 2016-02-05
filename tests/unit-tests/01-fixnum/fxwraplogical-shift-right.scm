(include "#.scm")

(check-eqv? (##fxwraplogical-shift-right 0 0) 0)
(check-eqv? (##fxwraplogical-shift-right -1 1) ##max-fixnum)
(check-eqv? (##fxwraplogical-shift-right 22 2) 5)
(check-eqv? (##fxwraplogical-shift-right 33 4) 2)

(check-eqv? (fxwraplogical-shift-right 0 0) 0)
(check-eqv? (fxwraplogical-shift-right -1 1) ##max-fixnum)
(check-eqv? (fxwraplogical-shift-right 22 2) 5)
(check-eqv? (fxwraplogical-shift-right 33 4) 2)

(check-tail-exn range-exception? (lambda () (fxwraplogical-shift-right 1 ##min-fixnum)))

(check-tail-exn type-exception? (lambda () (fxwraplogical-shift-right 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxwraplogical-shift-right 1 1/2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraplogical-shift-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraplogical-shift-right 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxwraplogical-shift-right 1 2 3)))
