(include "#.scm")

(test-equal
 "abcd"
 (with-output-to-string (lambda () (write-string "abcd"))))

(test-equal
 "abcd"
 (call-with-output-string (lambda (port) (write-string "abcd" port))))

(test-equal
 "abcd"
 (call-with-output-string (lambda (port) (write-string "ab" port) (write-string "cd" port))))

(test-equal
 "bcd"
 (call-with-output-string (lambda (port) (write-string "abcd" port 1))))

(test-equal
 ""
 (call-with-output-string (lambda (port) (write-string "abcd" port 4))))

(test-equal
 "bcd"
 (call-with-output-string (lambda (port) (write-string "abcd" port 1 4))))

(test-equal
 ""
 (call-with-output-string (lambda (port) (write-string "abcd" port 1 1))))

(test-equal
 "bc"
 (call-with-output-string (lambda (port) (write-string "abcd" port 1 3))))

(test-error-tail wrong-number-of-arguments-exception? (write-string))
(test-error-tail wrong-number-of-arguments-exception? (write-string "abcd" (current-output-port) 1 3 #f))

(test-error-tail type-exception? (write-string #f))
(test-error-tail type-exception? (write-string "abcd" #f))
(test-error-tail type-exception? (write-string "abcd" (current-output-port) #f))
(test-error-tail type-exception? (write-string "abcd" (current-output-port) 1 #f))

(test-error-tail range-exception? (write-string "abcd" (current-output-port) -1 3))
(test-error-tail range-exception? (write-string "abcd" (current-output-port) 0 5))
(test-error-tail range-exception? (write-string "abcd" (current-output-port) 3 2))
