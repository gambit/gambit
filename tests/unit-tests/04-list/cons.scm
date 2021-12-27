(include "#.scm")

(check-equal? (cons 1 2) '(1 . 2))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (cons)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (cons 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (cons 1 2 3)))
