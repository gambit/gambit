(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-equal? (take-right lst1 0) '())
(check-equal? (take-right lst1 1) '(33))
(check-equal? (take-right lst1 2) '(22 33))
(check-equal? (take-right lst1 3) '(11 22 33))

(check-equal? (take-right lst2 0) '())
(check-equal? (take-right lst2 1) '(44))
(check-equal? (take-right lst2 2) '(33 44))
(check-equal? (take-right lst2 3) '(22 33 44))
(check-equal? (take-right lst2 4) '(11 22 33 44))

(check-equal? (take-right bool 0) bool)
(check-equal? (take-right '(1 2 . 3) 0) 3)
(check-equal? (take-right '(1 2 . 3) 1) '(2 . 3))
(check-equal? (take-right '(1 2 . 3) 2) '(1 2 . 3))

(check-tail-exn range-exception? (lambda () (take-right lst1 4)))
(check-tail-exn range-exception? (lambda () (take-right lst1 -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take-right lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (take-right lst1 0 0)))
