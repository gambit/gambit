(include "#.scm")

;; serdes.scm calls these only inside helpers, so the coverage walker
;; never records them. Competing #1033 memory_ports.scm also omits them.
(test-assert (u8vector? (object->u8vector '(a 1))))
(test-equal '(a 1) (u8vector->object (object->u8vector '(a 1))))
(test-equal
 123
 (u8vector->object (object->u8vector 123 (lambda (x) x)) (lambda (x) x)))

(test-error-tail wrong-number-of-arguments-exception? (object->u8vector))
(test-error-tail wrong-number-of-arguments-exception? (u8vector->object))
(test-error-tail type-exception? (u8vector->object 'nope))
