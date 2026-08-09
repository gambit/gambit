(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(test-equal 99 (fold list 99 lst0))
(test-equal '(11 99) (fold list 99 lst1))
(test-equal '(22 (11 99)) (fold list 99 lst2))

(test-equal 99 (fold list 99 lst0 '()))
(test-equal '(11 1 99) (fold list 99 lst1 '(1)))
(test-equal '(22 2 (11 1 99)) (fold list 99 lst2 '(1 2)))

;; these checks verify that lists of different lengths can be used
(test-equal 99 (fold list 99 lst1 '()))
(test-equal 99 (fold list 99 '() lst1))
(test-equal '(11 1 99) (fold list 99 lst2 '(1)))
(test-equal '(1 11 99) (fold list 99 '(1) lst2))
(test-equal 99 (fold list 99 lst2 '()))
(test-equal 99 (fold list 99 '() lst2))

(test-equal 99 (fold list 99 lst0 lst0 '()))
(test-equal '(11 11 1 99) (fold list 99 lst1 lst1 '(1)))
(test-equal '(22 22 2 (11 11 1 99)) (fold list 99 lst2 lst2 '(1 2)))

;; these checks verify that lists of different lengths can be used
(test-equal 99 (fold list 99 lst1 lst1 '()))
(test-equal 99 (fold list 99 lst1 '() lst1))
(test-equal 99 (fold list 99 '() lst1 lst1))
(test-equal '(11 11 1 99) (fold list 99 lst2 lst2 '(1)))
(test-equal '(11 1 11 99) (fold list 99 lst2 '(1) lst2))
(test-equal '(1 11 11 99) (fold list 99 '(1) lst2 lst2))
(test-equal 99 (fold list 99 lst2 lst2 '()))
(test-equal 99 (fold list 99 lst2 '() lst2))
(test-equal 99 (fold list 99 '() lst2 lst2))

(test-error-tail type-exception? (fold #f 99 lst0))
(test-error-tail type-exception? (fold list 99 #f))
(test-error-tail type-exception? (fold list 99 '(1 2 . #f)))
(test-error-tail type-exception? (fold list 99 '(1 2) #f))
(test-error-tail type-exception? (fold list 99 '(1 2) '(3 4 . #f)))
(test-error-tail type-exception? (fold list 99 #f '(1 2)))
(test-error-tail type-exception? (fold list 99 '(3 4 . #f) '(1 2)))

(test-error-tail wrong-number-of-arguments-exception? (fold))
(test-error-tail wrong-number-of-arguments-exception? (fold list))
(test-error-tail wrong-number-of-arguments-exception? (fold list 99))
