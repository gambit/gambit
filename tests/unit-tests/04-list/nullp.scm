(include "#.scm")

(define null '())
(define pair (cons 11 22))

(check-equal? (null? #f) #f)
(check-equal? (null? null) #t)
(check-equal? (null? 123) #f)
(check-equal? (null? '(1 . 2)) #f)
(check-equal? (null? pair) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (null?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (null? 0 0)))
