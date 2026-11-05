(include "#.scm")

(test-assert (string? (this-source-file)))
(test-assert (> (string-length (this-source-file)) 0))
