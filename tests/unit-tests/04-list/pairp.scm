(include "#.scm")

(define null '())
(define pair (cons 11 22))

(check-equal? (pair? #f) #f)
(check-equal? (pair? null) #f)
(check-equal? (pair? 123) #f)
(check-equal? (pair? '(1 . 2)) #t)
(check-equal? (pair? pair) #t)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (pair?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (pair? 0 0)))
