(include "#.scm")

(test-equal '#u8(97) (with-output-to-u8vector (lambda () (write-u8 97))))

(test-equal
 '#u8(97 10 98)
 (with-output-to-u8vector
  (lambda () (write-u8 97) (write-u8 10) (write-u8 98))))

(test-equal
 '#u8(97 10 98)
 (call-with-output-u8vector
  (lambda (port) (write-u8 97 port) (write-u8 10 port) (write-u8 98 port))))

(test-error-tail wrong-number-of-arguments-exception? (write-u8))
(test-error-tail
 wrong-number-of-arguments-exception?
 (write-u8 97 (current-output-port) #f))

(test-error-tail type-exception? (write-u8 #f))
(test-error-tail type-exception? (write-u8 97 #f))
