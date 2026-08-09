(include "#.scm")

(test-equal "123\n" (with-output-to-string (lambda () (pretty-print 123))))

(test-equal
 "-45678901234567890\n"
 (with-output-to-string (lambda () (pretty-print -45678901234567890))))

(test-equal "1.25\n" (with-output-to-string (lambda () (pretty-print 1.25))))

(test-equal "#t\n" (with-output-to-string (lambda () (pretty-print #t))))

(test-equal "#f\n" (with-output-to-string (lambda () (pretty-print #f))))

(test-equal
 "#\\space\n"
 (with-output-to-string (lambda () (pretty-print #\space))))

(test-equal
 "\"hello\\nworld\"\n"
 (with-output-to-string (lambda () (pretty-print "hello\nworld"))))

(test-equal "sym\n" (with-output-to-string (lambda () (pretty-print 'sym))))

(test-equal "key:\n" (with-output-to-string (lambda () (pretty-print 'key:))))

(test-equal
 "#(1 2 3)\n"
 (with-output-to-string (lambda () (pretty-print '#(1 2 3)))))

(test-equal
 "(1 2 . 3)\n"
 (with-output-to-string (lambda () (pretty-print '(1 2 . 3)))))

(test-equal "()\n" (with-output-to-string (lambda () (pretty-print '()))))

(test-equal
 "\"hello\\nworld\"\n"
 (call-with-output-string (lambda (port) (pretty-print "hello\nworld" port))))

(test-error-tail wrong-number-of-arguments-exception? (pretty-print))
(test-error-tail
 wrong-number-of-arguments-exception?
 (pretty-print #f (current-output-port) #f))

(test-error-tail type-exception? (pretty-print #f #f))
