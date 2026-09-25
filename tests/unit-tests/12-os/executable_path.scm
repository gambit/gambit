(include "#.scm")

(test-assert (string? (executable-path)))
(test-assert (> (string-length (executable-path)) 0))
(test-error-tail wrong-number-of-arguments-exception? (executable-path #f))
