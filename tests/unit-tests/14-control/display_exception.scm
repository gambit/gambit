(include "#.scm")

(define e
  (with-exception-catcher
   (lambda (x) x)
   (lambda () (error "boom" 1 2))))

(define s
  (call-with-output-string
   (lambda (p) (display-exception e p))))

(test-assert (string? s))
(test-assert (> (string-length s) 0))
(test-assert (string? (call-with-output-string
                       (lambda (p) (display-exception e p)))))

(test-error-tail wrong-number-of-arguments-exception? (display-exception))
(test-error-tail type-exception? (display-exception e 'not-a-port))
