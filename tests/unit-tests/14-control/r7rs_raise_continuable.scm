(include "#.scm")

(test-eq
 123
 (with-exception-handler
  (lambda (e) e)
  (lambda () (r7rs-raise-continuable 123))))
