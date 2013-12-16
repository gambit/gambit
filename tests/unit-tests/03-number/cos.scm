(include "#.scm")

;;; Test special values

(check-eqv? (cos 0) 1)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (cos 'a)))

