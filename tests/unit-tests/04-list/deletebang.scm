(include "#.scm")

(check-equal? (delete! 5 '()) '())

(let ((nums (iota 20)))
  (check-equal? (delete! 5 nums)
                '(0 1 2 3 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
  (check-equal? nums (iota 20)))

(let ((nums (iota 20)))
  (check-equal? (delete! 5 nums <)
                '(0 1 2 3 4 5))
  (check-equal? nums (iota 20)))

(let ((nums (iota 20)))
  (check-equal? (delete! 5 nums >)
                '(5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))
  (check-equal? nums (iota 20)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (delete!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (delete! 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (delete! 1 '() < 4)))
(check-tail-exn type-exception? (lambda () (delete! 5 1)))
(check-tail-exn type-exception? (lambda () (delete! 5 (cons 1 2))))
(check-tail-exn type-exception? (lambda () (delete! 5 '() 99)))
