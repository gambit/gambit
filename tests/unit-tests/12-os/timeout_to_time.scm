(include "#.scm")

(test-assert (time? (timeout->time #f)))
(test-assert (time? (timeout->time 0)))
(test-assert (time? (timeout->time 1.5)))
(let ((t (current-time)))
  (test-eq t (timeout->time t)))

(test-error-tail type-exception? (timeout->time 'nope))
(test-error-tail wrong-number-of-arguments-exception? (timeout->time))
(test-error-tail wrong-number-of-arguments-exception? (timeout->time 1 2))
