(include "#.scm")

(check-false (thread? 0))
(check-false (thread? #f))
(check-false (thread? "hello"))

(check-true  (thread? (current-thread)))

;; other cases of threads are checked in make-thread.scm

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread? #f #f)))
