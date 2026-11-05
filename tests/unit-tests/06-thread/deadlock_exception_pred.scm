(include "#.scm")

(test-assert (procedure? deadlock-exception?))
(test-eq #f (deadlock-exception? #f))
(test-eq #f (deadlock-exception? 1))
