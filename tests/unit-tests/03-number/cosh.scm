(include "#.scm")

;;; Test special values

(check-eqv? (cosh 0) 1)
(check-eqv? (cosh 1) (cos +i))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (cosh 'a)))

