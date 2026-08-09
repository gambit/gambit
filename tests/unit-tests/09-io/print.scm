(include "#.scm")

(test-equal
 ""
 (with-output-to-string (lambda () (print))))

(test-equal
 "123"
 (with-output-to-string (lambda () (print 123))))

(test-equal
 "123"
 (with-output-to-string (lambda () (print 1 2 3))))

(test-equal
 "1234567"
 (with-output-to-string
  (lambda () (print 1 (list (cons 2 3) (vector 4 5) 6) 7))))

(test-equal
 "123"
 (call-with-output-string (lambda (port) (print port: port 1 2 3))))

(test-equal
 "\n"
 (with-output-to-string (lambda () (println))))

(test-equal
 "123\n"
 (with-output-to-string (lambda () (println 123))))

(test-equal
 "123\n"
 (with-output-to-string (lambda () (println 1 2 3))))

(test-equal
 "1234567\n"
 (with-output-to-string
  (lambda () (println 1 (list (cons 2 3) (vector 4 5) 6) 7))))

(test-equal
 "123\n"
 (call-with-output-string (lambda (port) (println port: port 1 2 3))))

(test-error-tail type-exception? (print port: #f 123))
(test-error-tail type-exception? (println port: #f 123))
