(include "#.scm")

(test-assert (eq? #f (thread? 0)))
(test-assert (eq? #f (thread? #f)))
(test-assert (eq? #f (thread? "hello")))

(test-assert (eq? #t (thread? (current-thread))))

;; other cases of threads are checked in make-thread.scm

(test-error-tail wrong-number-of-arguments-exception? (thread?))
(test-error-tail wrong-number-of-arguments-exception? (thread? #f #f))
