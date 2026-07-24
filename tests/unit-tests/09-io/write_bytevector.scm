(include "#.scm")

(test-equal
 '#u8(97 98 99 100)
 (with-output-to-u8vector (lambda () (write-bytevector '#u8(97 98 99 100)))))

(test-equal
 '#u8(97 98 99 100)
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port))))

(test-equal
 '#u8(97 98 99 100)
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98) port) (write-bytevector '#u8(99 100) port))))

(test-equal
 '#u8(98 99 100)
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port 1))))

(test-equal
 '#u8()
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port 4))))

(test-equal
 '#u8(98 99 100)
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port 1 4))))

(test-equal
 '#u8()
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port 1 1))))

(test-equal
 '#u8(98 99)
 (call-with-output-u8vector (lambda (port) (write-bytevector '#u8(97 98 99 100) port 1 3))))

(test-error-tail wrong-number-of-arguments-exception? (write-bytevector))
(test-error-tail wrong-number-of-arguments-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) 1 3 #f))

(test-error-tail type-exception? (write-bytevector #f))
(test-error-tail type-exception? (write-bytevector '#u8(97 98 99 100) #f))
(test-error-tail type-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) #f))
(test-error-tail type-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) 1 #f))

(test-error-tail range-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) -1 3))
(test-error-tail range-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) 0 5))
(test-error-tail range-exception? (write-bytevector '#u8(97 98 99 100) (current-output-port) 3 2))
