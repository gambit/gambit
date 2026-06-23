(include "#.scm")

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))
(define lst3 (list 22 44))

(test-equal #f (any odd? lst0))
(test-equal #t (any odd? lst1))
(test-equal #t (any odd? lst2))
(test-equal #f (any odd? lst3))

;; these checks verify that lists of different lengths can be used
(test-equal #f (any <= lst1 lst0))
(test-equal #t (any <= lst1 lst2))
(test-equal #f (any <= lst3 lst1))

;; these checks verify that lists of different lengths can be used
(test-equal #f (any <= lst1 lst0 lst3))
(test-equal #t (any <= lst1 lst2 lst3))
(test-equal #f (any <= lst3 lst1 lst3))

(test-error-tail type-exception? (any #f lst0))
(test-error-tail type-exception? (any odd? #f))
(test-error-tail type-exception? (any odd? '(2 4 . #f)))
(test-error-tail type-exception? (any > '(2 4) #f))
(test-error-tail type-exception? (any > '(2 4) '(3 4 . #f)))
(test-error-tail type-exception? (any > #f '(1 2)))
(test-error-tail type-exception? (any > '(2 4 . #f) '(3 4)))

(test-error-tail wrong-number-of-arguments-exception? (any))
(test-error-tail wrong-number-of-arguments-exception? (any odd?))
