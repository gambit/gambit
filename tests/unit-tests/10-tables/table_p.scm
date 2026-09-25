(include "#.scm")

(test-assert (table? (list->table '((a . 1)))))
(test-eq #f (table? 123))
(test-eq #f (table? '()))
(test-error-tail wrong-number-of-arguments-exception? (table?))
(test-error-tail wrong-number-of-arguments-exception? (table? 1 2))
