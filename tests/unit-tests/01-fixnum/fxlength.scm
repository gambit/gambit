(include "#.scm")

(check-eqv? (##fxlength 0) 0)
(check-eqv? (##fxlength -1) 0)

(check-eqv? (##fxlength -536870912) 29)
(check-eqv? (##fxlength  536870911) 29)

(if (fixnum? 2305843009213693951)
    (begin
      (check-eqv? (##fxlength -2305843009213693952) 61)
      (check-eqv? (##fxlength  2305843009213693951) 61)))

(check-eqv? (fxlength 0) 0)
(check-eqv? (fxlength -1) 0)

(check-eqv? (fxlength -536870912) 29)
(check-eqv? (fxlength  536870911) 29)

(if (fixnum? 2305843009213693951)
    (begin
      (check-eqv? (fxlength -2305843009213693952) 61)
      (check-eqv? (fxlength  2305843009213693951) 61)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxlength)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxlength 1 1)))

(check-tail-exn type-exception? (lambda () (fxlength 0.0)))
(check-tail-exn type-exception? (lambda () (fxlength 0.5)))
(check-tail-exn type-exception? (lambda () (fxlength 1/2)))
