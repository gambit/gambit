(include "#.scm")

(test-equal '#() (string->vector ""))
(test-equal '#(#\a #\b #\c #\d #\e) (string->vector "abcde"))
(test-equal '#(#\c #\d #\e) (string->vector "abcde" 2))
(test-equal '#(#\c #\d) (string->vector "abcde" 2 4))

(test-error-tail type-exception? (string->vector #f))
(test-error-tail type-exception? (string->vector "abcde" #f))
(test-error-tail type-exception? (string->vector "abcde" 0 #f))
(test-error-tail range-exception? (string->vector "abcde" 8))
(test-error-tail range-exception? (string->vector "abcde" 4 2))

(test-error-tail wrong-number-of-arguments-exception? (string->vector))
(test-error-tail wrong-number-of-arguments-exception? (string->vector "" 0 0 #f))
