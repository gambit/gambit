(include "#.scm")

(define lst1 (list 1 2 3 4))

(check-equal? (append-reverse lst1 '()) '(4 3 2 1))
(check-equal? (append-reverse lst1 '(5 6)) '(4 3 2 1 5 6))
(check-equal? (append-reverse lst1 5) '(4 3 2 1 . 5))

(check-tail-exn type-exception? (lambda () (append-reverse #f '(5 6))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-reverse lst1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (append-reverse lst1 '() #f)))
