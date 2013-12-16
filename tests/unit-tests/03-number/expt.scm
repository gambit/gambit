(include "#.scm")

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (expt 'a 2)))
(check-tail-exn type-exception? (lambda () (expt 2 'a)))

