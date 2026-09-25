(include "#.scm")

(define e
  (with-exception-catcher
   (lambda (x) x)
   (lambda () (error "boom"))))

(test-assert
 (string?
  (continuation-capture
   (lambda (k)
     (call-with-output-string
      (lambda (p)
        (display-exception-in-context e k p)))))))

(test-assert
 (> (string-length
     (continuation-capture
      (lambda (k)
        (call-with-output-string
         (lambda (p)
           (display-exception-in-context e k p))))))
    0))

(test-error-tail wrong-number-of-arguments-exception? (display-exception-in-context))
(test-error-tail
 type-exception?
 (continuation-capture
  (lambda (k)
    (display-exception-in-context e k 'not-a-port))))
