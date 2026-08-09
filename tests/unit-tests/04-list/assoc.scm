(include "#.scm")

(test-equal #f (assq '() '()))
(test-equal #f (assq '() '((1 . 11) (2 . 22))))
(test-equal '(() . 22) (assq '() '((1 . 11) (() . 22))))
(test-equal '(() . 22) (assq '() '((1 . 11) (() . 22) (() . 33))))
(test-equal
 #f
 (assq (+ 100000000000000000000 5)
       '((1 . 11) (100000000000000000005 . 22) (3 . 33))))
(test-equal #f (assq (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))))

(test-error-tail type-exception? (assq '() #f))
(test-error-tail type-exception? (assq '() '(1 2 3)))

(test-error-tail wrong-number-of-arguments-exception? (assq))
(test-error-tail wrong-number-of-arguments-exception? (assq '()))
(test-error-tail wrong-number-of-arguments-exception? (assq '() '() =))

(test-equal #f (assv '() '()))
(test-equal #f (assv '() '((1 . 11) (2 . 22))))
(test-equal '(() . 22) (assv '() '((1 . 11) (() . 22))))
(test-equal '(() . 22) (assv '() '((1 . 11) (() . 22) (() . 33))))
(test-equal
 '(100000000000000000000 . 22)
 (assv 100000000000000000000
       '((1 . 11) (100000000000000000000 . 22) (3 . 33))))
(test-equal #f (assv (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))))

(test-error-tail type-exception? (assv '() #f))
(test-error-tail type-exception? (assv '() '(1 2 3)))

(test-error-tail wrong-number-of-arguments-exception? (assv))
(test-error-tail wrong-number-of-arguments-exception? (assv '()))
(test-error-tail wrong-number-of-arguments-exception? (assv '() '() =))

(test-equal #f (assoc '() '()))
(test-equal #f (assoc '() '((1 . 11) (2 . 22))))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22))))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22) (() . 33))))
(test-equal
 '(100000000000000000000 . 22)
 (assoc 100000000000000000000
        '((1 . 11) (100000000000000000000 . 22) (3 . 33))))
(test-equal
 '((1 . 2) . 22)
 (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))))

(test-error-tail type-exception? (assoc '() #f))
(test-error-tail type-exception? (assoc '() '(1 2 3)))
(test-error-tail type-exception? (assoc '() '() #f))

(test-error-tail wrong-number-of-arguments-exception? (assoc))
(test-error-tail wrong-number-of-arguments-exception? (assoc '()))
(test-error-tail wrong-number-of-arguments-exception? (assoc '() '() = #f))

(test-equal #f (assoc '() '() eq?))
(test-equal #f (assoc '() '((1 . 11) (2 . 22)) eq?))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22)) eq?))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22) (() . 33)) eq?))
(test-equal
 #f
 (assoc (+ 100000000000000000000 5)
        '((1 . 11) (100000000000000000005 . 22) (3 . 33))
        eq?))
(test-equal #f (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33)) eq?))

(test-equal #f (assoc '() '() eqv?))
(test-equal #f (assoc '() '((1 . 11) (2 . 22)) eqv?))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22)) eqv?))
(test-equal '(() . 22) (assoc '() '((1 . 11) (() . 22) (() . 33)) eqv?))
(test-equal
 '(100000000000000000000 . 22)
 (assoc 100000000000000000000
        '((1 . 11) (100000000000000000000 . 22) (3 . 33))
        eqv?))
(test-equal #f (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33)) eqv?))

(test-equal #f (assoc 2. '((1 . 11) (2 . 22) (3 . 33))))
(test-equal '(2 . 22) (assoc 2. '((1 . 11) (2 . 22) (3 . 33)) =))
