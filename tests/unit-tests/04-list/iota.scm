(include "#.scm")

(define bool #f)

(check-equal? (iota 0) '())
(check-equal? (iota 1) '(0))
(check-equal? (iota 2) '(0 1))
(check-equal? (iota 3) '(0 1 2))
(check-equal? (iota 4) '(0 1 2 3))
(check-equal? (iota 4 3) '(3 4 5 6))
(check-equal? (iota 4 10 2) '(10 12 14 16))
(check-equal? (iota 4 10 -1) '(10 9 8 7))

(check-equal? (iota 4 10 0.5) '(10 10.5 11.0 11.5))

(check-equal? (iota 4 10 0) '(10 10 10 10))
(check-equal? (iota 4 10 0.0) '(10 10.0 10.0 10.0))
(check-equal? (iota 4 10.0 1) '(10.0 11.0 12.0 13.0))

(check-tail-exn type-exception? (lambda () (iota bool)))
(check-tail-exn type-exception? (lambda () (iota bool 0)))
(check-tail-exn type-exception? (lambda () (iota 0 bool)))
(check-tail-exn type-exception? (lambda () (iota bool 0 0)))
(check-tail-exn type-exception? (lambda () (iota 0 bool 0)))
(check-tail-exn type-exception? (lambda () (iota 0 0 bool)))

(check-tail-exn range-exception? (lambda () (iota -1)))
(check-tail-exn range-exception? (lambda () (iota -1 0)))
(check-tail-exn range-exception? (lambda () (iota -1 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (iota)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (iota 0 0 0 0)))
