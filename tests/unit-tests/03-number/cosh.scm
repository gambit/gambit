(include "#.scm")

;;; Test special values

(test-eqv 1 (cosh 0))
(test-eqv (cos +i) (cosh 1))

(test-eqv .5403023058681398 (cosh +i))
;; Issue #902

;;; Test exceptions

(test-error-tail type-exception? (cosh 'a))

