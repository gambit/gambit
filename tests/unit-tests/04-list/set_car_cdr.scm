(include "#.scm")

(define bool #f)
(define pair (cons 11 22))

(check-eq? (set-car! pair 55) (void))
(check-equal? pair '(55 . 22))

(check-tail-exn type-exception? (lambda () (set-car! bool 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-car!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-car! pair)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-car! pair 0 0)))

(check-eq? (set-cdr! pair 66) (void))
(check-equal? pair '(55 . 66))

(check-tail-exn type-exception? (lambda () (set-cdr! bool 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-cdr!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-cdr! pair)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (set-cdr! pair 0 0)))
