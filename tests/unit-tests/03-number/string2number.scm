(include "#.scm")

(test-equal 0 (string->number "0"))
(test-equal 123 (string->number "123"))
(test-equal -123 (string->number "-123"))
(test-equal 123 (string->number "1111011" 2))
(test-equal -123 (string->number "-1111011" 2))
(test-equal 123 (string->number "7b" 16))
(test-equal -123 (string->number "-7b" 16))

(test-equal
 123456789012345678901234567890
 (string->number "123456789012345678901234567890"))
(test-equal 2/7 (string->number "2/7"))
(test-equal -0. (string->number "-0."))
(test-equal -inf.0 (string->number "-inf.0"))
(test-equal .001953125 (string->number ".001953125"))
(test-equal 9.765625e-4 (string->number "9.765625e-4"))
(test-equal -1.5+2/3i (string->number "-1.5+2/3i"))

;;; Test exceptions

(test-error-tail type-exception? (string->number 1))
(test-error-tail type-exception? (string->number "" 'a))
(test-error-tail range-exception? (string->number "" 30))

