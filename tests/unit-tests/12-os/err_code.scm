(include "#.scm")

(test-assert (string? (err-code->string 0)))
(test-assert (string? (err-code->string -1)))
(test-error-tail wrong-number-of-arguments-exception? (err-code->string))
(test-error-tail wrong-number-of-arguments-exception? (err-code->string 0 1))
