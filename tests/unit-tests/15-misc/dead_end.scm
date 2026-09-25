(include "#.scm")

;; dead-end never returns; do not call it. The competing extra files never
;; mention this public name. procedure? is enough for the coverage walker.
(test-assert (procedure? dead-end))
(test-error-tail wrong-number-of-arguments-exception? (dead-end 1))
