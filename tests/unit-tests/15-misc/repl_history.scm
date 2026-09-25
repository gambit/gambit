(include "#.scm")

(test-eq (void) (repl-result-history-max-length-set! 8))
(test-eq (void) (repl-result-history-max-length-set! 0))

(test-error-tail range-exception? (repl-result-history-ref 0))
(test-error-tail range-exception? (repl-result-history-max-length-set! -1))
(test-error-tail wrong-number-of-arguments-exception? (repl-result-history-ref))
(test-error-tail wrong-number-of-arguments-exception? (repl-result-history-ref 0 1))
(test-error-tail wrong-number-of-arguments-exception? (repl-result-history-max-length-set!))
(test-error-tail wrong-number-of-arguments-exception? (repl-result-history-max-length-set! 1 2))
