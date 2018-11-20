(include "#.scm")

(check-equal? (assq '() '()) #f)
(check-equal? (assq '() '((1 . 11) (2 . 22))) #f)
(check-equal? (assq '() '((1 . 11) (() . 22))) '(() . 22))
(check-equal? (assq '() '((1 . 11) (() . 22) (() . 33))) '(() . 22))
(check-equal? (assq 100000000000000000000 '((1 . 11) (100000000000000000000 . 22) (3 . 33))) #f)
(check-equal? (assq (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))) #f)

(check-tail-exn type-exception? (lambda () (assq '() #f)))
(check-tail-exn type-exception? (lambda () (assq '() '(1 2 3))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assq)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assq '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assq '() '() =)))

(check-equal? (assv '() '()) #f)
(check-equal? (assv '() '((1 . 11) (2 . 22))) #f)
(check-equal? (assv '() '((1 . 11) (() . 22))) '(() . 22))
(check-equal? (assv '() '((1 . 11) (() . 22) (() . 33))) '(() . 22))
(check-equal? (assv 100000000000000000000 '((1 . 11) (100000000000000000000 . 22) (3 . 33))) '(100000000000000000000 . 22))
(check-equal? (assv (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))) #f)

(check-tail-exn type-exception? (lambda () (assv '() #f)))
(check-tail-exn type-exception? (lambda () (assv '() '(1 2 3))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assv)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assv '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assv '() '() =)))

(check-equal? (assoc '() '()) #f)
(check-equal? (assoc '() '((1 . 11) (2 . 22))) #f)
(check-equal? (assoc '() '((1 . 11) (() . 22))) '(() . 22))
(check-equal? (assoc '() '((1 . 11) (() . 22) (() . 33))) '(() . 22))
(check-equal? (assoc 100000000000000000000 '((1 . 11) (100000000000000000000 . 22) (3 . 33))) '(100000000000000000000 . 22))
(check-equal? (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33))) '((1 . 2) . 22))

(check-tail-exn type-exception? (lambda () (assoc '() #f)))
(check-tail-exn type-exception? (lambda () (assoc '() '(1 2 3))))
(check-tail-exn type-exception? (lambda () (assoc '() '() #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assoc)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assoc '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (assoc '() '() = #f)))

(check-equal? (assoc '() '() eq?) #f)
(check-equal? (assoc '() '((1 . 11) (2 . 22)) eq?) #f)
(check-equal? (assoc '() '((1 . 11) (() . 22)) eq?) '(() . 22))
(check-equal? (assoc '() '((1 . 11) (() . 22) (() . 33)) eq?) '(() . 22))
(check-equal? (assoc 100000000000000000000 '((1 . 11) (100000000000000000000 . 22) (3 . 33)) eq?) #f)
(check-equal? (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33)) eq?) #f)

(check-equal? (assoc '() '() eqv?) #f)
(check-equal? (assoc '() '((1 . 11) (2 . 22)) eqv?) #f)
(check-equal? (assoc '() '((1 . 11) (() . 22)) eqv?) '(() . 22))
(check-equal? (assoc '() '((1 . 11) (() . 22) (() . 33)) eqv?) '(() . 22))
(check-equal? (assoc 100000000000000000000 '((1 . 11) (100000000000000000000 . 22) (3 . 33)) eqv?) '(100000000000000000000 . 22))
(check-equal? (assoc (cons 1 2) '((1 . 11) ((1 . 2) . 22) (() . 33)) eqv?) #f)

(check-equal? (assoc 2.0 '((1 . 11) (2 . 22) (3 . 33))) #f)
(check-equal? (assoc 2.0 '((1 . 11) (2 . 22) (3 . 33)) =) '(2 . 22))
