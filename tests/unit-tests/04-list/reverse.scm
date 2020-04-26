(include "#.scm")

(define lst1 (list 1 2 3 4))
(define lst2 (reverse lst1))
(define lst3 (reverse lst1 5))

(check-equal? lst1 '(1 2 3 4))
(check-equal? lst2 '(4 3 2 1))
(check-equal? lst3 '(4 3 2 1 . 5))

(check-equal? (reverse '()) '())
(check-equal? (reverse '() 5) 5)

(check-tail-exn type-exception? (lambda () (reverse #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (reverse)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (reverse lst1 #f #f)))
