(include "#.scm")

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (abs #\c)))
(check-tail-exn type-exception? (lambda () (abs +i)))

