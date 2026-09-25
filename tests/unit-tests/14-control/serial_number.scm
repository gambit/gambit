(include "#.scm")

(define n (object->serial-number 'hello))
(test-assert (integer? n))
(test-eq 'hello (serial-number->object n))

(define x (list 1 2))
(test-eq x (serial-number->object (object->serial-number x)))

(test-eq 'missing (serial-number->object 999999999 'missing))

(test-error-tail wrong-number-of-arguments-exception? (object->serial-number))
(test-error-tail wrong-number-of-arguments-exception? (object->serial-number 1 2))
(test-error-tail type-exception? (serial-number->object 'nope))
(test-error-tail wrong-number-of-arguments-exception? (serial-number->object))
(test-error-tail wrong-number-of-arguments-exception? (serial-number->object 1 2 3))
