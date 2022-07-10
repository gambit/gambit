(include "#.scm")

(define lst1 (list 8 3 1 2 4))

(check-equal? (list-sort! < '()) '())
(check-equal? (list-sort! < lst1) '(1 2 3 4 8))

(check-tail-exn type-exception? (lambda () (list-sort! < #f)))
(check-tail-exn type-exception? (lambda () (list-sort! #f lst1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-sort!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-sort! < lst1 #f)))
