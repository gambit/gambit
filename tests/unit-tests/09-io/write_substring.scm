(include "#.scm")

(test-equal
 "abcd"
 (with-output-to-string (lambda () (write-substring "abcd" 0 4))))

(test-equal
 "bc"
 (with-output-to-string (lambda () (write-substring "abcd" 1 3))))

(test-equal
 "bcd"
 (with-output-to-string (lambda () (write-substring "abcd" 1 4))))

(test-equal
 ""
 (with-output-to-string (lambda () (write-substring "abcd" 1 1))))

(test-equal
 "abcd"
 (call-with-output-string (lambda (port) (write-substring "abcd" 0 4 port))))

(test-equal
 "bc"
 (call-with-output-string (lambda (port) (write-substring "abcd" 1 3 port))))

(test-error-tail wrong-number-of-arguments-exception? (write-substring))
(test-error-tail wrong-number-of-arguments-exception? (write-substring "abcd"))
(test-error-tail wrong-number-of-arguments-exception? (write-substring "abcd" 1))
(test-error-tail wrong-number-of-arguments-exception? (write-substring "abcd" 1 3 (current-output-port) #f))

(test-error-tail type-exception? (write-substring #f 1 3))
(test-error-tail type-exception? (write-substring "abcd" #f 3))
(test-error-tail type-exception? (write-substring "abcd" 1 #f))
(test-error-tail type-exception? (write-substring "abcd" 1 3 #f))

(test-error-tail range-exception? (write-substring "abcd" -1 3 (current-output-port)))
(test-error-tail range-exception? (write-substring "abcd" 0 5 (current-output-port)))
(test-error-tail range-exception? (write-substring "abcd" 3 2 (current-output-port)))
