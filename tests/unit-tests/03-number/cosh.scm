(include "#.scm")

;;; Test special values

(check-eqv? (cosh 0) 1)

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (cosh 'a)))

