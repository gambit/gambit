(include "#.scm")

(define null '())
(define pair (cons 11 22))

(test-equal #f (null? #f))
(test-equal #t (null? null))
(test-equal #f (null? 123))
(test-equal #f (null? '(1 . 2)))
(test-equal #f (null? pair))

(test-error-tail wrong-number-of-arguments-exception? (null?))
(test-error-tail wrong-number-of-arguments-exception? (null? 0 0))
