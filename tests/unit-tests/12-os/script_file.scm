(include "#.scm")

(check-equal? (script-file) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (script-file #f)))
