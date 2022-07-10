(include "#.scm")

(check-equal? (script-directory) #f)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (script-directory #f)))
