(include "#.scm")

(define lst1 (cons 1 (cons 2 3)))
(define lst2 (cons 1 (cons 2 (cons 3 4))))

(check-eq? (last-pair lst1) (cdr lst1))
(check-eq? (last-pair lst2) (cddr lst2))

(check-tail-exn type-exception? (lambda () (last-pair #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (last-pair)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (last-pair lst1 #f)))

