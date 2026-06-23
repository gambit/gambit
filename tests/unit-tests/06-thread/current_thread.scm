(include "#.scm")

(test-assert (eq? #t (thread? (current-thread))))

(test-eq (current-thread) (current-thread))

(test-error-tail wrong-number-of-arguments-exception? (current-thread #f))
