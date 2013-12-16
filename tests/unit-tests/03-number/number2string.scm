(include "#.scm")

(check-equal? (number->string 0) "0")
(check-equal? (number->string 123) "123")
(check-equal? (number->string -123) "-123")
(check-equal? (number->string 123 2) "1111011")
(check-equal? (number->string -123 2) "-1111011")
(check-equal? (number->string 123 16) "7b")
(check-equal? (number->string -123 16) "-7b")

(check-equal? (number->string 123456789012345678901234567890) "123456789012345678901234567890")
(check-equal? (number->string 2/7) "2/7")
(check-equal? (number->string -0.) "-0.")
(check-equal? (number->string -inf.0) "-inf.0")
(check-equal? (number->string .001953125) ".001953125")
(check-equal? (number->string 9.765625e-4) "9.765625e-4")
(check-equal? (number->string -1.5+2/3i) "-1.5+2/3i")

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (number->string 'a)))
(check-tail-exn type-exception? (lambda () (number->string 1 'a)))
(check-tail-exn range-exception? (lambda () (number->string 1 30)))

