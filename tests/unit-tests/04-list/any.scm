(include "#.scm")

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))
(define lst3 (list 22 44))

(check-equal? (any odd? lst0) #f)
(check-equal? (any odd? lst1) #t)
(check-equal? (any odd? lst2) #t)
(check-equal? (any odd? lst3) #f)

;; these checks verify that lists of different lengths can be used
(check-equal? (any <= lst1 lst0) #f)
(check-equal? (any <= lst1 lst2) #t)
(check-equal? (any <= lst3 lst1) #f)

;; these checks verify that lists of different lengths can be used
(check-equal? (any <= lst1 lst0 lst3) #f)
(check-equal? (any <= lst1 lst2 lst3) #t)
(check-equal? (any <= lst3 lst1 lst3) #f)

(check-tail-exn type-exception? (lambda () (any #f lst0)))
(check-tail-exn type-exception? (lambda () (any odd? #f)))
(check-tail-exn type-exception? (lambda () (any odd? '(2 4 . #f))))
(check-tail-exn type-exception? (lambda () (any > '(2 4) #f)))
(check-tail-exn type-exception? (lambda () (any > '(2 4) '(3 4 . #f))))
(check-tail-exn type-exception? (lambda () (any > #f '(1 2))))
(check-tail-exn type-exception? (lambda () (any > '(2 4 . #f) '(3 4))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (any)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (any odd?)))
