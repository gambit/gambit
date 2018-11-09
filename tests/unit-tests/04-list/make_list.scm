(include "#.scm")

(define bool #f)

(check-equal? (make-list 0) '())
(check-equal? (make-list 1) '(0))
(check-equal? (make-list 2) '(0 0))
(check-equal? (make-list 3 99) '(99 99 99))

(check-tail-exn type-exception? (lambda () (make-list bool)))

(check-tail-exn range-exception? (lambda () (make-list -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-list)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-list 0 0 0)))
