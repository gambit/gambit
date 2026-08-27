(include "#.scm")

(test-equal "" (vector->string '#()))
(test-equal "abcde" (vector->string '#(#\a #\b #\c #\d #\e)))
(test-equal "cde" (vector->string '#(#\a #\b #\c #\d #\e) 2))
(test-equal "cd" (vector->string '#(#\a #\b #\c #\d #\e) 2 4))

(test-error-tail type-exception? (vector->string #f))
(test-error-tail type-exception? (vector->string '#() #f))
(test-error-tail type-exception? (vector->string '#() 0 #f))
(test-error-tail range-exception? (vector->string '#(#\a #\b #\c #\d #\e) 8))
(test-error-tail range-exception? (vector->string '#(#\a #\b #\c #\d #\e) 4 2))

(test-error-tail wrong-number-of-arguments-exception? (vector->string))
(test-error-tail wrong-number-of-arguments-exception? (vector->string '#() 0 0 #f))
