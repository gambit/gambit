(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-equal? (drop lst1 0) '(11 22 33))
(check-equal? (drop lst1 1) '(22 33))
(check-equal? (drop lst1 2) '(33))
(check-equal? (drop lst1 3) '())

(check-equal? (drop lst2 0) '(11 22 33 44))
(check-equal? (drop lst2 1) '(22 33 44))
(check-equal? (drop lst2 2) '(33 44))
(check-equal? (drop lst2 3) '(44))
(check-equal? (drop lst2 4) '())

(check-equal? (drop bool 0) bool)
(check-equal? (drop '(1 2 . 3) 2) 3)

(check-tail-exn range-exception? (lambda () (drop lst1 4)))
(check-tail-exn range-exception? (lambda () (drop lst1 -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop lst1 0 0)))
