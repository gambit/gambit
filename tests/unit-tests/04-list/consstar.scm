(include "#.scm")

(check-equal? (cons* 1) 1)
(check-equal? (cons* 1 2) '(1 . 2))
(check-equal? (cons* 1 2 3) '(1 2 . 3))
(check-equal? (cons* 1 2 3 4) '(1 2 3 . 4))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (cons*)))
