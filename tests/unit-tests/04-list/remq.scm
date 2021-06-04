(include "#.scm")

(check-equal? (remq 1 '()) '())

(let* ((lst1 '(a b a a b a))
       (lst2 (list-copy lst1)))
  (check-equal? (remq 'a lst2) '(b b))
  (check-equal? lst1 lst2)
  (check-equal? (remq 'c lst2) lst2))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remq)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remq 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (remq 1 '() 3)))
(check-tail-exn type-exception? (lambda () (remq 1 '(1 . 2))))
