(include "#.scm")

(define lst0 '())
(define lst1 '(22))
(define lst2 (list 11 22))
(define lst3 (list 22 44))

(test-equal #t (every even? lst0))
(test-equal #t (every even? lst1))
(test-equal #f (every even? lst2))
(test-equal #t (every even? lst3))

;; these checks verify that lists of different lengths can be used
(test-equal #t (every <= lst1 lst0))
(test-equal #f (every <= lst1 lst2))
(test-equal #t (every <= lst3 lst1))

;; these checks verify that lists of different lengths can be used
(test-equal #t (every <= lst1 lst0 lst3))
(test-equal #f (every <= lst1 lst2 lst3))
(test-equal #t (every <= lst3 lst1 lst3))

(test-error-tail type-exception? (every #f lst0))
(test-error-tail type-exception? (every even? #f))
(test-error-tail type-exception? (every even? '(2 4 . #f)))
(test-error-tail type-exception? (every < '(2 4) #f))
(test-error-tail type-exception? (every < '(2 4) '(3 4 . #f)))
(test-error-tail type-exception? (every < #f '(1 2)))
(test-error-tail type-exception? (every < '(2 4 . #f) '(3 4)))

(test-error-tail wrong-number-of-arguments-exception? (every))
(test-error-tail wrong-number-of-arguments-exception? (every even?))
