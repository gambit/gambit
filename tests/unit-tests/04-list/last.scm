(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))
(define lst2 (cons 1 (cons 2 (cons 3 4))))

(check-equal? (last lst1) 2)
(check-equal? (last lst2) 3)

(check-tail-exn type-exception? (lambda () (last #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (last)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (last lst1 #f)))

