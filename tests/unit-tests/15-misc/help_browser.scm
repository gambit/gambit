(include "#.scm")

(define old (help-browser))
(test-assert (string? old))
(help-browser "")
(test-equal "" (help-browser))
(help-browser old)
(test-eq old (help-browser))
(test-error-tail wrong-number-of-arguments-exception? (help-browser "" 1))
