(include "#.scm")

(test-error string? (raise "hello"))

(test-error divide-by-zero-exception? (quotient 123 0))
