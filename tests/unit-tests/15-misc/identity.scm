(include "#.scm")

(test-eq 42 (identity 42))
(test-eq 'x (identity 'x))
(test-eq #f (identity #f))
(test-eq (void) (void))
(test-eq (void) (poll-point))

(test-error-tail wrong-number-of-arguments-exception? (identity))
(test-error-tail wrong-number-of-arguments-exception? (identity 1 2))
(test-error-tail wrong-number-of-arguments-exception? (void 1))
(test-error-tail wrong-number-of-arguments-exception? (poll-point 1))
