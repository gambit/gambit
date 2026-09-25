(include "#.scm")

(test-assert
 (error-exception?
  (with-exception-catcher
   (lambda (e) e)
   (lambda () (error "boom")))))

(test-eq
 123
 (continuation-capture
  (lambda (k)
    (with-exception-handler
     (lambda (exc) (continuation-return k exc))
     (lambda () (r7rs-raise 123))))))
