(include "#.scm")

(test-eq 0 (main))
(test-eq 0 (main 1))
(test-eq 0 (main 1 2 3))
