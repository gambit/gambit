(include "#.scm")

(define lst0 '())
(define lst1 '(22))
(define lst2 (list 11 22))
(define lst3 (list 22 44))

(check-equal? (every even? lst0) #t)
(check-equal? (every even? lst1) #t)
(check-equal? (every even? lst2) #f)
(check-equal? (every even? lst3) #t)

;; these checks verify that lists of different lengths can be used
(check-equal? (every <= lst1 lst0) #t)
(check-equal? (every <= lst1 lst2) #f)
(check-equal? (every <= lst3 lst1) #t)

;; these checks verify that lists of different lengths can be used
(check-equal? (every <= lst1 lst0 lst3) #t)
(check-equal? (every <= lst1 lst2 lst3) #f)
(check-equal? (every <= lst3 lst1 lst3) #t)

(check-tail-exn type-exception? (lambda () (every #f lst0)))
(check-tail-exn type-exception? (lambda () (every even? #f)))
(check-tail-exn type-exception? (lambda () (every even? '(2 4 . #f))))
(check-tail-exn type-exception? (lambda () (every < '(2 4) #f)))
(check-tail-exn type-exception? (lambda () (every < '(2 4) '(3 4 . #f))))
(check-tail-exn type-exception? (lambda () (every < #f '(1 2))))
(check-tail-exn type-exception? (lambda () (every < '(2 4 . #f) '(3 4))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (every)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (every even?)))
