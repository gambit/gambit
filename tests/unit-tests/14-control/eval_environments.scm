(include "#.scm")

(test-eq 'interaction-environment (interaction-environment))
(test-eq 'null-environment (null-environment))
(test-eq 5 (scheme-report-environment 5))

(test-error-tail wrong-number-of-arguments-exception? (interaction-environment 1))
(test-error-tail wrong-number-of-arguments-exception? (null-environment 1))
(test-error-tail wrong-number-of-arguments-exception? (scheme-report-environment))
(test-error-tail wrong-number-of-arguments-exception? (scheme-report-environment 5 6))
