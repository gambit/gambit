(include "#.scm")

(test-eq #!eof (eof-object))
(test-assert (eof-object))

(test-assert (eof-object? (eof-object)))
(test-assert (not (eof-object? #f)))

(test-error-tail wrong-number-of-arguments-exception? (eof-object #f))

(test-error-tail wrong-number-of-arguments-exception? (eof-object?))
(test-error-tail wrong-number-of-arguments-exception? (eof-object? #f #f))
