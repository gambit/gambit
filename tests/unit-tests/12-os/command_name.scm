(include "#.scm")

(check-equal? (command-name) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (command-name #f)))
