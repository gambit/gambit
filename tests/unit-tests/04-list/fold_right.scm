(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(check-equal? (fold-right list 99 lst0) 99)
(check-equal? (fold-right list 99 lst1) '(11 99))
(check-equal? (fold-right list 99 lst2) '(11 (22 99)))

(check-equal? (fold-right list 99 lst0 '()) 99)
(check-equal? (fold-right list 99 lst1 '(1)) '(11 1 99))
(check-equal? (fold-right list 99 lst2 '(1 2)) '(11 1 (22 2 99)))

;; these checks verify that lists of different lengths can be used
(check-equal? (fold-right list 99 lst1 '()) 99)
(check-equal? (fold-right list 99 '() lst1) 99)
(check-equal? (fold-right list 99 lst2 '(1)) '(11 1 99))
(check-equal? (fold-right list 99 '(1) lst2) '(1 11 99))
(check-equal? (fold-right list 99 lst2 '()) 99)
(check-equal? (fold-right list 99 '() lst2) 99)

(check-equal? (fold-right list 99 lst0 lst0 '()) 99)
(check-equal? (fold-right list 99 lst1 lst1 '(1)) '(11 11 1 99))
(check-equal? (fold-right list 99 lst2 lst2 '(1 2)) '(11 11 1 (22 22 2 99)))

;; these checks verify that lists of different lengths can be used
(check-equal? (fold-right list 99 lst1 lst1 '()) 99)
(check-equal? (fold-right list 99 lst1 '() lst1) 99)
(check-equal? (fold-right list 99 '() lst1 lst1) 99)
(check-equal? (fold-right list 99 lst2 lst2 '(1)) '(11 11 1 99))
(check-equal? (fold-right list 99 lst2 '(1) lst2) '(11 1 11 99))
(check-equal? (fold-right list 99 '(1) lst2 lst2) '(1 11 11 99))
(check-equal? (fold-right list 99 lst2 lst2 '()) 99)
(check-equal? (fold-right list 99 lst2 '() lst2) 99)
(check-equal? (fold-right list 99 '() lst2 lst2) 99)

(check-tail-exn type-exception? (lambda () (fold-right #f 99 lst0)))
(check-tail-exn type-exception? (lambda () (fold-right list 99 #f)))
(check-tail-exn type-exception? (lambda () (fold-right list 99 '(1 2 . #f))))
(check-tail-exn type-exception? (lambda () (fold-right list 99 '(1 2) #f)))
(check-tail-exn type-exception? (lambda () (fold-right list 99 '(1 2) '(3 4 . #f))))
(check-tail-exn type-exception? (lambda () (fold-right list 99 #f '(1 2))))
(check-tail-exn type-exception? (lambda () (fold-right list 99 '(3 4 . #f) '(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right list 99)))
