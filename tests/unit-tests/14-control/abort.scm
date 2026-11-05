(include "#.scm")

(test-eq
 123
 (continuation-capture
  (lambda (k)
    (with-exception-handler
     (lambda (exc) (continuation-return k exc))
     (lambda () (abort 123))))))
