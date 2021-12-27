(include "#.scm")

(define bool #f)

(define a0 (cons 0 1))

(check-tail-exn type-exception? (lambda () (car+cdr bool)))
(check-equal? (call-with-values (lambda () (car+cdr a0)) list) '(0 1))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (car+cdr)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (car+cdr a0 a0)))
