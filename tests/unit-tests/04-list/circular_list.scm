(include "#.scm")

(define lst1 (circular-list 1))
(define lst2 (circular-list 1 2))
(define lst3 (circular-list 1 2 3))

(check-equal? (car lst1) 1)
(check-equal? (cadr lst1) 1)
(check-equal? (caddr lst1) 1)
(check-equal? (cadddr lst1) 1)

(check-equal? (car lst2) 1)
(check-equal? (cadr lst2) 2)
(check-equal? (caddr lst2) 1)
(check-equal? (cadddr lst2) 2)

(check-equal? (car lst3) 1)
(check-equal? (cadr lst3) 2)
(check-equal? (caddr lst3) 3)
(check-equal? (cadddr lst3) 1)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (circular-list)))
