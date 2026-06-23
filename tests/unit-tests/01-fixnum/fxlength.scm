(include "#.scm")

(test-eqv 0 (##fxlength 0))
(test-eqv 0 (##fxlength -1))

(test-eqv 29 (##fxlength -536870912))
(test-eqv 29 (##fxlength 536870911))

(if (fixnum? 2305843009213693951)
    (begin
      (test-eqv 61 (##fxlength -2305843009213693952))
      (test-eqv 61 (##fxlength 2305843009213693951))))

(test-eqv 0 (fxlength 0))
(test-eqv 0 (fxlength -1))

(test-eqv 29 (fxlength -536870912))
(test-eqv 29 (fxlength 536870911))

(if (fixnum? 2305843009213693951)
    (begin
      (test-eqv 61 (fxlength -2305843009213693952))
      (test-eqv 61 (fxlength 2305843009213693951))))

(test-error-tail wrong-number-of-arguments-exception? (fxlength))
(test-error-tail wrong-number-of-arguments-exception? (fxlength 1 1))

(test-error-tail type-exception? (fxlength 0.))
(test-error-tail type-exception? (fxlength .5))
(test-error-tail type-exception? (fxlength 1/2))
