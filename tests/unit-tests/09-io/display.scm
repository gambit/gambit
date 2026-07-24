(include "#.scm")

(test-equal
 "123"
 (with-output-to-string (lambda () (display 123))))

(test-equal
 "-45678901234567890"
 (with-output-to-string (lambda () (display -45678901234567890))))

(test-equal
 "1.25"
 (with-output-to-string (lambda () (display 1.25))))

(test-equal
 "#t"
 (with-output-to-string (lambda () (display #t))))

(test-equal
 "#f"
 (with-output-to-string (lambda () (display #f))))

(test-equal
 " "
 (with-output-to-string (lambda () (display #\space))))

(test-equal
 "hello\nworld"
 (with-output-to-string (lambda () (display "hello\nworld"))))

(test-equal
 "sym"
 (with-output-to-string (lambda () (display 'sym))))

(test-equal
 "key"
 (with-output-to-string (lambda () (display 'key:))))

(test-equal
 "#(1 2 3)"
 (with-output-to-string (lambda () (display '#(1 2 3)))))

(test-equal
 "(1 2 . 3)"
 (with-output-to-string (lambda () (display '(1 2 . 3)))))

(test-equal
 "()"
 (with-output-to-string (lambda () (display '()))))

(test-equal
 "hello\nworld"
 (call-with-output-string (lambda (port) (display "hello\nworld" port))))

(test-error-tail wrong-number-of-arguments-exception? (display))
(test-error-tail wrong-number-of-arguments-exception? (display #f (current-output-port) #f))

(test-error-tail type-exception? (display #f #f))
