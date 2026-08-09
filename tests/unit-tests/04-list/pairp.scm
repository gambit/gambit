(include "#.scm")

(define null '())
(define pair (cons 11 22))

(test-equal #f (pair? #f))
(test-equal #f (pair? null))
(test-equal #f (pair? 123))
(test-equal #t (pair? '(1 . 2)))
(test-equal #t (pair? pair))

(test-error-tail wrong-number-of-arguments-exception? (pair?))
(test-error-tail wrong-number-of-arguments-exception? (pair? 0 0))
