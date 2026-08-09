(include "#.scm")

(define bool #f)

(define a0 (cons 0 1))

(test-error-tail type-exception? (car+cdr bool))
(test-equal '(0 1) (call-with-values (lambda () (car+cdr a0)) list))
(test-error-tail wrong-number-of-arguments-exception? (car+cdr))
(test-error-tail wrong-number-of-arguments-exception? (car+cdr a0 a0))
