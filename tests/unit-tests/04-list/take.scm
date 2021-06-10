(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-equal? (take lst1 0) '())
(check-equal? (take lst1 1) '(11))
(check-equal? (take lst1 2) '(11 22))
(check-equal? (take lst1 3) '(11 22 33))

(check-equal? (take lst2 0) '())
(check-equal? (take lst2 1) '(11))
(check-equal? (take lst2 2) '(11 22))
(check-equal? (take lst2 3) '(11 22 33))
(check-equal? (take lst2 4) '(11 22 33 44))

(check-equal? (take bool 0) '())
(check-equal? (take '(1 2 . 3) 2) '(1 2))

(check-tail-exn range-exception? (lambda () (take lst1 4)))
(check-tail-exn range-exception? (lambda () (take lst1 -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take lst1 0 0)))
