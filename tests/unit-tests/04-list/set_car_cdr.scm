(include "#.scm")

(define bool #f)
(define pair (cons 11 22))

(test-eq (void) (set-car! pair 55))
(test-equal '(55 . 22) pair)

(test-error-tail type-exception? (set-car! bool 0))

(test-error-tail wrong-number-of-arguments-exception? (set-car!))
(test-error-tail wrong-number-of-arguments-exception? (set-car! pair))
(test-error-tail wrong-number-of-arguments-exception? (set-car! pair 0 0))

(test-eq (void) (set-cdr! pair 66))
(test-equal '(55 . 66) pair)

(test-error-tail type-exception? (set-cdr! bool 0))

(test-error-tail wrong-number-of-arguments-exception? (set-cdr!))
(test-error-tail wrong-number-of-arguments-exception? (set-cdr! pair))
(test-error-tail wrong-number-of-arguments-exception? (set-cdr! pair 0 0))
