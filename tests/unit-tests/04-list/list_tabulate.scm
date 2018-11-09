(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define (f x) (+ x 100))

(check-equal? (list-tabulate 0 f) '())
(check-equal? (list-tabulate 1 f) '(100))
(check-equal? (list-tabulate 2 f) '(100 101))
(check-equal? (list-tabulate 3 f) '(100 101 102))

(check-equal? (list-tabulate 0 list) '())
(check-equal? (list-tabulate 1 list) '((0)))
(check-equal? (list-tabulate 2 list) '((0) (1)))
(check-equal? (list-tabulate 3 list) '((0) (1) (2)))

(check-tail-exn type-exception? (lambda () (list-tabulate bool f)))
(check-tail-exn type-exception? (lambda () (list-tabulate 0 bool)))

(check-tail-exn range-exception? (lambda () (list-tabulate -1 f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-tabulate)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-tabulate 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-tabulate 0 f 0)))
