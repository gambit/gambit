(include "#.scm")

(check-equal? (remove even? '()) '())

(let ((nums (iota 20)))
  (check-equal? (remove odd? nums)
                '(0 2 4 6 8 10 12 14 16 18))
  (check-equal? nums (iota 20)))

(check-equal? (remove even? (iota 20))
              '(1 3 5 7 9 11 13 15 17 19))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remove)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remove 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remove 1 2 3)))
(check-tail-exn type-exception? (lambda () (remove odd? '(1 . 2))))
