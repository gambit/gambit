(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(check-equal? (list-set lst1 0 99) '(99 22 33))
(check-equal? (list-set lst1 1 99) '(11 99 33))
(check-equal? (list-set lst1 2 99) '(11 22 99))

(check-eq? (list-set! lst2 0 55) (void))
(check-equal? lst2 '(55 22 33 44))
(check-eq? (list-set! lst2 1 66) (void))
(check-equal? lst2 '(55 66 33 44))
(check-eq? (list-set! lst2 2 77) (void))
(check-equal? lst2 '(55 66 77 44))
(check-eq? (list-set! lst2 3 88) (void))
(check-equal? lst2 '(55 66 77 88))

(check-tail-exn type-exception? (lambda () (list-set bool 0 11)))
(check-tail-exn type-exception? (lambda () (list-set lst1 bool 11)))

(check-tail-exn range-exception? (lambda () (list-set lst1 -1 0)))
(check-tail-exn range-exception? (lambda () (list-set lst1 3 0)))

(check-tail-exn type-exception? (lambda () (list-set! bool 0 11)))
(check-tail-exn type-exception? (lambda () (list-set! lst1 bool 11)))

(check-tail-exn range-exception? (lambda () (list-set! lst1 -1 0)))
(check-tail-exn range-exception? (lambda () (list-set! lst1 3 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-set! lst2)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-set! lst2 0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (list-set! lst2 0 0 0)))
