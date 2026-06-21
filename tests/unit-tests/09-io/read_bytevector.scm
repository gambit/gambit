(include "#.scm")

(test-equal
 '#u8()
 (with-input-from-u8vector '#u8() (lambda () (read-bytevector 0))))

(test-equal
 #!eof
 (with-input-from-u8vector '#u8() (lambda () (read-bytevector 1))))

(test-equal
 '#u8(97 98 99 100)
 (with-input-from-u8vector '#u8(97 98 99 100) (lambda () (read-bytevector 4))))

(test-equal
 '#u8(97 98 99 100)
 (with-input-from-u8vector '#u8(97 98 99 100) (lambda () (read-bytevector 9))))

(test-equal
 '#u8()
 (call-with-input-u8vector '#u8() (lambda (port) (read-bytevector 0 port))))

(test-equal
 #!eof
 (call-with-input-u8vector '#u8() (lambda (port) (read-bytevector 1 port))))

(test-equal
 '#u8(97 98 99 100)
 (call-with-input-u8vector '#u8(97 98 99 100) (lambda (port) (read-bytevector 4 port))))

(test-equal
 '#u8(97 98 99 100)
 (call-with-input-u8vector '#u8(97 98 99 100) (lambda (port ) (read-bytevector 9 port))))

(test-error-tail wrong-number-of-arguments-exception?
                 (read-bytevector))
(test-error-tail wrong-number-of-arguments-exception?
                 (read-bytevector 4 (current-input-port) #f))

(test-error-tail type-exception?
                 (read-bytevector #f))
(test-error-tail type-exception?
                 (read-bytevector #f (current-input-port)))
(test-error-tail type-exception?
                 (read-bytevector 4 #f))
