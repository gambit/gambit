(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))

(check-equal? (list-copy lst1) '(1 2 . 3))
(check-false (eq? (list-copy lst1) lst1))

(check-equal? (list-copy #f) #f)
(check-equal? (list-copy 'foo) 'foo)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-copy)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-copy lst1 #f)))
