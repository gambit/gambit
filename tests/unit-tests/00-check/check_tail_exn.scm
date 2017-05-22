(include "#.scm")

(check-tail-exn divide-by-zero-exception? (lambda () (quotient 123 0)))
