(include "#.scm")

(test-assert (procedure? foreign?))
(test-eq #f (foreign? #f))
(test-eq #f (foreign? 1))
(test-eq #f (foreign? "x"))
(test-eq #f (foreign? (current-output-port)))
(test-eq #f (foreign? (make-u8vector 1)))

(test-error-tail type-exception? (foreign-tags 1))
(test-error-tail type-exception? (foreign-address 1))
(test-error-tail type-exception? (foreign-released? 1))
(test-error-tail type-exception? (foreign-release! 1))
