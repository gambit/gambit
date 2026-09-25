(include "#.scm")

(test-equal "(1 2 3)" (object->string '(1 2 3)))
(test-equal "123" (object->string 123))
(test-equal "(1 ..." (object->string '(1 2 3 4 5) 6))
(test-error-tail wrong-number-of-arguments-exception? (object->string))
(test-error-tail wrong-number-of-arguments-exception? (object->string 1 2 3))
