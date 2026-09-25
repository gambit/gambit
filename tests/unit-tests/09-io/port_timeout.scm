(include "#.scm")

(define in (open-input-string "x"))
(test-eq (void) (input-port-timeout-set! in +inf.0))
(test-eq (void) (input-port-timeout-set! in +inf.0 (lambda () #f)))
(close-port in)

(define out (open-output-string))
(test-eq (void) (output-port-timeout-set! out +inf.0))
(test-eq (void) (output-port-timeout-set! out +inf.0 (lambda () #f)))
(close-port out)

(test-error-tail type-exception? (input-port-timeout-set! 1 +inf.0))
(test-error-tail type-exception? (output-port-timeout-set! 1 +inf.0))
(test-error-tail wrong-number-of-arguments-exception? (input-port-timeout-set!))
(test-error-tail wrong-number-of-arguments-exception? (output-port-timeout-set!))
