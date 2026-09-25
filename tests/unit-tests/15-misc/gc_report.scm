(include "#.scm")

(test-eq (void) (gc-report-set! #t))
(test-eq (void) (gc-report-set! #f))

(test-error-tail wrong-number-of-arguments-exception? (gc-report-set!))
(test-error-tail wrong-number-of-arguments-exception? (gc-report-set! #t #f))
