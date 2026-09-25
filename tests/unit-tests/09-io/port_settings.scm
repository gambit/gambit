(include "#.scm")

(test-error-tail type-exception? (port-settings-set! 1 '()))
(test-error-tail wrong-number-of-arguments-exception? (port-settings-set!))
(test-error-tail wrong-number-of-arguments-exception? (port-settings-set! 1 '() 2))
