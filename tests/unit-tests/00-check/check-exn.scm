(include "#.scm")

(check-exn string? (lambda () (raise "hello") 123))

(check-exn divide-by-zero-exception? (lambda () (quotient 123 0)))
