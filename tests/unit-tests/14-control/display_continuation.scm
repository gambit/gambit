(include "#.scm")

(test-assert
 (> (string-length
     (continuation-capture
      (lambda (k)
        (call-with-output-string
         (lambda (p)
           (display-continuation-backtrace k p))))))
    0))

(test-assert
 (string?
  (continuation-capture
   (lambda (k)
     (call-with-output-string
      (lambda (p)
        (display-continuation-environment k p)))))))

(test-assert
 (string?
  (continuation-capture
   (lambda (k)
     (call-with-output-string
      (lambda (p)
        (display-continuation-dynamic-environment k p)))))))

(test-assert
 (string?
  (call-with-output-string
   (lambda (p)
     (display-procedure-environment display p)))))

(test-error-tail wrong-number-of-arguments-exception? (display-continuation-backtrace))
(test-error-tail wrong-number-of-arguments-exception? (display-procedure-environment))
(test-error-tail type-exception? (display-continuation-backtrace 1))
(test-error-tail type-exception? (display-continuation-environment 1))
(test-error-tail type-exception? (display-continuation-dynamic-environment 1))
(test-error-tail type-exception? (display-procedure-environment 1))
