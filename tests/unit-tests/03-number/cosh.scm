(include "#.scm")

;;; Test special values

(check-eqv? (cosh 0) 1)
(check-eqv? (cosh 1) (cos +i))

(check-eqv? (cosh +i) .5403023058681398)   ;; Issue #902

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (cosh 'a)))

