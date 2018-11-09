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

(check-equal? (fold-right list 99 lst0 lst0 '()) 99)
(check-equal? (fold-right list 99 lst1 lst1 '(1)) '(11 11 1 99))
(check-equal? (fold-right list 99 lst2 lst2 '(1 2)) '(11 11 1 (22 22 2 99)))

(check-tail-exn type-exception? (lambda () (fold-right bool 99 lst0)))
(check-tail-exn type-exception? (lambda () (fold-right list 99 bool)))
(check-tail-exn type-exception? (lambda () (fold-right list 99 lst0 bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fold-right list 99)))
