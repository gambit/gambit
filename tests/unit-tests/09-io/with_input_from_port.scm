(include "#.scm")

(test-equal
 #\x
 (let ((p (open-input-string "x")))
   (with-input-from-port p read-char)))

(test-error-tail type-exception? (with-input-from-port 1 (lambda () 0)))
(test-error-tail type-exception? (with-input-from-port (open-input-string "x") 1))
(test-error-tail wrong-number-of-arguments-exception? (with-input-from-port (open-input-string "x")))
