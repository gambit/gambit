(include "#.scm")

(check-equal? (exact->inexact 123.0) 123.0)
(check-equal? (exact->inexact 0.5) 0.5)
(check-equal? (exact->inexact 123) 123.0)
(check-equal? (exact->inexact 1/2) 0.5)
(check-equal? (exact->inexact 1/2+3/4i) 0.5+0.75i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (exact->inexact 'a)))

