(include "#.scm")

(test-error-tail type-exception? (thread-suspend! 1))
(test-error-tail type-exception? (thread-resume! 1))
(test-error-tail wrong-number-of-arguments-exception? (thread-suspend!))
(test-error-tail wrong-number-of-arguments-exception? (thread-resume!))
(test-error-tail wrong-number-of-arguments-exception? (thread-suspend! (current-thread) 1))
