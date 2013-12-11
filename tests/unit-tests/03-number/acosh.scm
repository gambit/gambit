(include "#.scm")

;;; Test special values

(check-eqv? (acosh 1) 0)

;;; Test branch cuts

(check-= (acosh 0)    (test-acosh 0))
(check-= (acosh +0.i) (test-acosh +0.i))
(check-= (acosh -0.i) (test-acosh -0.i))
