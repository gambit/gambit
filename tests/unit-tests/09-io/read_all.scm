(include "#.scm")

(test-equal
 '()
 (with-input-from-string "" (lambda () (read-all))))

(test-equal
 '(123)
 (with-input-from-string "123" (lambda () (read-all))))

(test-equal
 '(1 2 3)
 (with-input-from-string "1 2 3" (lambda () (read-all))))

(test-equal
 '(1 2 3)
 (with-input-from-string "1\n2\n3\n" (lambda () (read-all))))

(test-equal
 '(1 2 3)
 (call-with-input-string "1\n2\n3\n" (lambda (port) (read-all port))))

(test-equal
 '(1 2 3)
 (call-with-input-string "1\n2\n3\n" (lambda (port) (read-all port read))))

(test-equal
 '(#\1 #\newline #\2 #\newline #\3 #\newline)
 (call-with-input-string "1\n2\n3\n" (lambda (port) (read-all port read-char))))

(test-error-tail wrong-number-of-arguments-exception? (read-all (current-input-port) read #f))

(test-error-tail type-exception? (read-all #f))
(test-error-tail type-exception? (read-all (current-input-port) #f))
