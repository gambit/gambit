(include "#.scm")

(check-equal? (xcons 1 2) '(2 . 1))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (xcons)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (xcons 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (xcons 1 2 3)))
