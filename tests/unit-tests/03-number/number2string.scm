(include "#.scm")

(test-equal "0" (number->string 0))
(test-equal "123" (number->string 123))
(test-equal "-123" (number->string -123))
(test-equal "1111011" (number->string 123 2))
(test-equal "-1111011" (number->string -123 2))
(test-equal "7b" (number->string 123 16))
(test-equal "-7b" (number->string -123 16))

(test-equal
 "123456789012345678901234567890"
 (number->string 123456789012345678901234567890))
(test-equal "2/7" (number->string 2/7))
(test-equal "-0." (number->string -0.))
(test-equal "-inf.0" (number->string -inf.0))
(test-equal ".001953125" (number->string .001953125))
(test-equal "9.765625e-4" (number->string 9.765625e-4))
(test-equal "-1.5+2/3i" (number->string -1.5+2/3i))

;;; Test exceptions

(test-error-tail type-exception? (number->string 'a))
(test-error-tail type-exception? (number->string 1 'a))
(test-error-tail range-exception? (number->string 1 30))

