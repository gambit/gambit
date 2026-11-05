(include "#.scm")

(test-eqv 4 (digit-value #\4))
(test-eq #f (digit-value #\x))
(test-error-tail type-exception? (digit-value 4))
(test-error-tail wrong-number-of-arguments-exception? (digit-value))
(test-error-tail wrong-number-of-arguments-exception? (digit-value #\4 #\5))
