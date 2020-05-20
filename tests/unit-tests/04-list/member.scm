(include "#.scm")

(check-equal? (memq '() '()) #f)
(check-equal? (memq '() '(1 2)) #f)
(check-equal? (memq '() '(1 ())) '(()))
(check-equal? (memq '() '(1 () ())) '(() ()))
(check-equal? (memq (+ 100000000000000000000 5) '(1 100000000000000000005 3)) #f)
(check-equal? (memq (cons 1 2) '(1 (1 . 2) ())) #f)

(check-tail-exn type-exception? (lambda () (memq '() #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memq)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memq '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memq '() '() =)))

(check-equal? (memv '() '()) #f)
(check-equal? (memv '() '(1 2)) #f)
(check-equal? (memv '() '(1 ())) '(()))
(check-equal? (memv '() '(1 () ())) '(() ()))
(check-equal? (memv 100000000000000000000 '(1 100000000000000000000 3)) '(100000000000000000000 3))
(check-equal? (memv (cons 1 2) '(1 (1 . 2) ())) #f)

(check-tail-exn type-exception? (lambda () (memv '() #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memv)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memv '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (memv '() '() =)))

(check-equal? (member '() '()) #f)
(check-equal? (member '() '(1 2)) #f)
(check-equal? (member '() '(1 ())) '(()))
(check-equal? (member '() '(1 () ())) '(() ()))
(check-equal? (member 100000000000000000000 '(1 100000000000000000000 3)) '(100000000000000000000 3))
(check-equal? (member (cons 1 2) '(1 (1 . 2) ())) '((1 . 2) ()))

(check-tail-exn type-exception? (lambda () (member '() #f)))
(check-tail-exn type-exception? (lambda () (member '() '() #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (member)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (member '())))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (member '() '() = #f)))

(check-equal? (member '() '() eq?) #f)
(check-equal? (member '() '(1 2) eq?) #f)
(check-equal? (member '() '(1 ()) eq?) '(()))
(check-equal? (member '() '(1 () ()) eq?) '(() ()))
(check-equal? (member (+ 100000000000000000000 5) '(1 100000000000000000005 3) eq?) #f)
(check-equal? (member (cons 1 2) '(1 (1 . 2) ()) eq?) #f)

(check-equal? (member '() '() eqv?) #f)
(check-equal? (member '() '(1 2) eqv?) #f)
(check-equal? (member '() '(1 ()) eqv?) '(()))
(check-equal? (member '() '(1 () ()) eqv?) '(() ()))
(check-equal? (member 100000000000000000000 '(1 100000000000000000000 3) eqv?) '(100000000000000000000 3))
(check-equal? (member (cons 1 2) '(1 (1 . 2) ()) eqv?) #f)

(check-equal? (member 2.0 '(1 2 3)) #f)
(check-equal? (member 2.0 '(1 2 3) =) '(2 3))
