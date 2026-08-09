(include "#.scm")

(test-equal #f (memq '() '()))
(test-equal #f (memq '() '(1 2)))
(test-equal '(()) (memq '() '(1 ())))
(test-equal '(() ()) (memq '() '(1 () ())))
(test-equal #f (memq (+ 100000000000000000000 5) '(1 100000000000000000005 3)))
(test-equal #f (memq (cons 1 2) '(1 (1 . 2) ())))

(test-error-tail type-exception? (memq '() #f))

(test-error-tail wrong-number-of-arguments-exception? (memq))
(test-error-tail wrong-number-of-arguments-exception? (memq '()))
(test-error-tail wrong-number-of-arguments-exception? (memq '() '() =))

(test-equal #f (memv '() '()))
(test-equal #f (memv '() '(1 2)))
(test-equal '(()) (memv '() '(1 ())))
(test-equal '(() ()) (memv '() '(1 () ())))
(test-equal
 '(100000000000000000000 3)
 (memv 100000000000000000000 '(1 100000000000000000000 3)))
(test-equal #f (memv (cons 1 2) '(1 (1 . 2) ())))

(test-error-tail type-exception? (memv '() #f))

(test-error-tail wrong-number-of-arguments-exception? (memv))
(test-error-tail wrong-number-of-arguments-exception? (memv '()))
(test-error-tail wrong-number-of-arguments-exception? (memv '() '() =))

(test-equal #f (member '() '()))
(test-equal #f (member '() '(1 2)))
(test-equal '(()) (member '() '(1 ())))
(test-equal '(() ()) (member '() '(1 () ())))
(test-equal
 '(100000000000000000000 3)
 (member 100000000000000000000 '(1 100000000000000000000 3)))
(test-equal '((1 . 2) ()) (member (cons 1 2) '(1 (1 . 2) ())))

(test-error-tail type-exception? (member '() #f))
(test-error-tail type-exception? (member '() '() #f))

(test-error-tail wrong-number-of-arguments-exception? (member))
(test-error-tail wrong-number-of-arguments-exception? (member '()))
(test-error-tail wrong-number-of-arguments-exception? (member '() '() = #f))

(test-equal #f (member '() '() eq?))
(test-equal #f (member '() '(1 2) eq?))
(test-equal '(()) (member '() '(1 ()) eq?))
(test-equal '(() ()) (member '() '(1 () ()) eq?))
(test-equal
 #f
 (member (+ 100000000000000000000 5) '(1 100000000000000000005 3) eq?))
(test-equal #f (member (cons 1 2) '(1 (1 . 2) ()) eq?))

(test-equal #f (member '() '() eqv?))
(test-equal #f (member '() '(1 2) eqv?))
(test-equal '(()) (member '() '(1 ()) eqv?))
(test-equal '(() ()) (member '() '(1 () ()) eqv?))
(test-equal
 '(100000000000000000000 3)
 (member 100000000000000000000 '(1 100000000000000000000 3) eqv?))
(test-equal #f (member (cons 1 2) '(1 (1 . 2) ()) eqv?))

(test-equal #f (member 2. '(1 2 3)))
(test-equal '(2 3) (member 2. '(1 2 3) =))
