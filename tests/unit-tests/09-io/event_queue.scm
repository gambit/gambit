(include "#.scm")

(test-error-tail type-exception? (open-event-queue 'nope))
(test-error-tail wrong-number-of-arguments-exception? (open-event-queue))
(test-error-tail wrong-number-of-arguments-exception? (open-event-queue 0 1))

(let ((p (open-event-queue 0)))
  (test-assert (port? p))
  (close-port p))
