(include "#.scm")

(test-assert
 (string?
  (call-with-output-string
   (lambda (p)
     (top 0 (thread-thread-group (current-thread)) p)))))
