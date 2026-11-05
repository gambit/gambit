(include "#.scm")

(test-equal
 "x"
 (let ((p (open-output-string)))
   (with-output-to-port p (lambda () (display "x")))
   (get-output-string p)))

(test-error-tail type-exception? (with-output-to-port 1 (lambda () 0)))
(test-error-tail type-exception? (with-output-to-port (open-output-string) 1))
(test-error-tail wrong-number-of-arguments-exception? (with-output-to-port (open-output-string)))
