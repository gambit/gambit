(include "#.scm")

(test-eqv 0 (##fxwraplogical-shift-right 0 0))
(test-eqv (##greatest-fixnum) (##fxwraplogical-shift-right -1 1))
(test-eqv 5 (##fxwraplogical-shift-right 22 2))
(test-eqv 2 (##fxwraplogical-shift-right 33 4))

(test-eqv 0 (fxwraplogical-shift-right 0 0))
(test-eqv (##greatest-fixnum) (fxwraplogical-shift-right -1 1))
(test-eqv 5 (fxwraplogical-shift-right 22 2))
(test-eqv 2 (fxwraplogical-shift-right 33 4))

(test-error-tail
 range-exception?
 (fxwraplogical-shift-right 1 (##least-fixnum)))

(test-error-tail type-exception? (fxwraplogical-shift-right 1 0.))
(test-error-tail type-exception? (fxwraplogical-shift-right 1 .5))
(test-error-tail type-exception? (fxwraplogical-shift-right .5 1))
(test-error-tail type-exception? (fxwraplogical-shift-right 1 1/2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraplogical-shift-right))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraplogical-shift-right 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (fxwraplogical-shift-right 1 2 3))
