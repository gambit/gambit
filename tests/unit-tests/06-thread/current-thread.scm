(include "#.scm")

(check-true (thread? (current-thread)))

(check-eq? (current-thread) (current-thread))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (current-thread #f)))
