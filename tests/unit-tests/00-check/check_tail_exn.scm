(include "#.scm")

(test-error-tail divide-by-zero-exception? (quotient 123 0))
