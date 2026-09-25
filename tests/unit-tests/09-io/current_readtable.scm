(include "#.scm")

;; current-readtable is a parameter; extra args raise nontail, not test-error-tail.
(test-assert (readtable? (current-readtable)))
