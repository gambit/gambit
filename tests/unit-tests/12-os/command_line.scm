(include "#.scm")

(check-equal? (command-line) '(""))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (command-line #f)))
