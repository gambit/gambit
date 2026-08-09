(include "#.scm")

(test-equal "" (with-input-from-string "" (lambda () (read-string 0))))

(test-equal #!eof (with-input-from-string "" (lambda () (read-string 1))))

(test-equal "abcd" (with-input-from-string "abcd" (lambda () (read-string 4))))

(test-equal "abcd" (with-input-from-string "abcd" (lambda () (read-string 9))))

(test-equal
 ""
 (call-with-input-string "" (lambda (port) (read-string 0 port))))

(test-equal
 #!eof
 (call-with-input-string "" (lambda (port) (read-string 1 port))))

(test-equal
 "abcd"
 (call-with-input-string "abcd" (lambda (port) (read-string 4 port))))

(test-equal
 "abcd"
 (call-with-input-string "abcd" (lambda (port) (read-string 9 port))))

(test-error-tail wrong-number-of-arguments-exception? (read-string))
(test-error-tail
 wrong-number-of-arguments-exception?
 (read-string 4 (current-input-port) #f))

(test-error-tail type-exception? (read-string #f))
(test-error-tail type-exception? (read-string #f (current-input-port)))
(test-error-tail type-exception? (read-string 4 #f))
