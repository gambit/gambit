(include "#.scm")

(check-equal? (inexact->exact 123) 123)
(check-equal? (inexact->exact 1/2) 1/2)
(check-equal? (inexact->exact 123.0) 123)
(check-equal? (inexact->exact 0.5) 1/2)
(check-equal? (inexact->exact 0.5+0.75i) 1/2+3/4i)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (inexact->exact 'a)))

