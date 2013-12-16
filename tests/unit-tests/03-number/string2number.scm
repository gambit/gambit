(include "#.scm")

(check-equal? (string->number "0") 0)
(check-equal? (string->number "123") 123)
(check-equal? (string->number "-123") -123)
(check-equal? (string->number "1111011" 2) 123)
(check-equal? (string->number "-1111011" 2) -123)
(check-equal? (string->number "7b" 16) 123)
(check-equal? (string->number "-7b" 16) -123)

(check-equal? (string->number "123456789012345678901234567890") 123456789012345678901234567890)
(check-equal? (string->number "2/7") 2/7)
(check-equal? (string->number "-0.") -0.)
(check-equal? (string->number "-inf.0") -inf.0)
(check-equal? (string->number ".001953125") .001953125)
(check-equal? (string->number "9.765625e-4") 9.765625e-4)
(check-equal? (string->number "-1.5+2/3i") -1.5+2/3i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (string->number 1)))
(check-tail-exn type-exception? (lambda () (string->number "" 'a)))
(check-tail-exn range-exception? (lambda () (string->number "" 30)))

