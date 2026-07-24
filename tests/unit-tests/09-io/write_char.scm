(include "#.scm")

(test-equal
 "a"
 (with-output-to-string (lambda () (write-char #\a))))

(test-equal
 "a\nb"
 (with-output-to-string (lambda () (write-char #\a) (write-char #\newline) (write-char #\b))))

(test-equal
 "a\nb"
 (call-with-output-string (lambda (port) (write-char #\a port) (write-char #\newline port) (write-char #\b port))))

(test-error-tail wrong-number-of-arguments-exception? (write-char))
(test-error-tail wrong-number-of-arguments-exception? (write-char #\a (current-output-port) #f))

(test-error-tail type-exception? (write-char #f))
(test-error-tail type-exception? (write-char #\a #f))
