(include "#.scm")

(define lst1 (list 1 2 3 4))
(define lst2 (reverse lst1))

(check-equal? lst1 '(1 2 3 4))
(check-equal? lst2 '(4 3 2 1))

(check-equal? (reverse '()) '())

(check-tail-exn type-exception? (lambda () (reverse #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (reverse)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (reverse lst1 #f)))

