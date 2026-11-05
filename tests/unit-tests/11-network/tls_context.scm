(include "#.scm")

(test-assert (with-exception-catcher
              (lambda (e) #t)
              (lambda () (foreign? (make-tls-context)))))
(test-error-tail wrong-number-of-arguments-exception? (make-tls-context 1))
