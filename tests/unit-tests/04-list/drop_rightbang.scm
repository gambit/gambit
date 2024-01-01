(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-equal? (drop-right! (append lst1 '()) 0) '(11 22 33))
(check-equal? (drop-right! (append lst1 '()) 1) '(11 22))
(check-equal? (drop-right! (append lst1 '()) 2) '(11))
(check-equal? (drop-right! (append lst1 '()) 3) '())

(check-equal? (drop-right! (append lst2 '()) 0) '(11 22 33 44))
(check-equal? (drop-right! (append lst2 '()) 1) '(11 22 33))
(check-equal? (drop-right! (append lst2 '()) 2) '(11 22))
(check-equal? (drop-right! (append lst2 '()) 3) '(11))
(check-equal? (drop-right! (append lst2 '()) 4) '())

(check-equal? (drop-right! bool 0) '())
(check-equal? (drop-right! (cons 1 (cons 2 3)) 0) '(1 2))
(check-equal? (drop-right! (cons 1 (cons 2 3)) 1) '(1))
(check-equal? (drop-right! (cons 1 (cons 2 3)) 2) '())

(check-tail-exn range-exception? (lambda () (drop-right! (append lst1 '()) 4)))
(check-tail-exn range-exception? (lambda () (drop-right! (append lst1 '()) -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop-right!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop-right! (append lst1 '()))))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (drop-right! (append lst1 '()) 0 0)))
