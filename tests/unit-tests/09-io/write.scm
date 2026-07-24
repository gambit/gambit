(include "#.scm")

(test-equal
 "123"
 (with-output-to-string (lambda () (write 123))))

(test-equal
 "-45678901234567890"
 (with-output-to-string (lambda () (write -45678901234567890))))

(test-equal
 "1.25"
 (with-output-to-string (lambda () (write 1.25))))

(test-equal
 "#t"
 (with-output-to-string (lambda () (write #t))))

(test-equal
 "#f"
 (with-output-to-string (lambda () (write #f))))

(test-equal
 "#\\space"
 (with-output-to-string (lambda () (write #\space))))

(test-equal
 "\"hello\\nworld\""
 (with-output-to-string (lambda () (write "hello\nworld"))))

(test-equal
 "sym"
 (with-output-to-string (lambda () (write 'sym))))

(test-equal
 "key:"
 (with-output-to-string (lambda () (write 'key:))))

(test-equal
 "#(1 2 3)"
 (with-output-to-string (lambda () (write '#(1 2 3)))))

(test-equal
 "(1 2 . 3)"
 (with-output-to-string (lambda () (write '(1 2 . 3)))))

(test-equal
 "()"
 (with-output-to-string (lambda () (write '()))))

(test-equal
 "\"hello\\nworld\""
 (call-with-output-string (lambda (port) (write "hello\nworld" port))))

(test-error-tail wrong-number-of-arguments-exception? (write))
(test-error-tail wrong-number-of-arguments-exception? (write #f (current-output-port) #f))

(test-error-tail type-exception? (write #f #f))
