(include "#.scm")

(test-equal
 '#u8(97 98 99 100)
 (with-output-to-u8vector
  (lambda () (write-subu8vector '#u8(97 98 99 100) 0 4))))

(test-equal
 '#u8(98 99)
 (with-output-to-u8vector
  (lambda () (write-subu8vector '#u8(97 98 99 100) 1 3))))

(test-equal
 '#u8(98 99 100)
 (with-output-to-u8vector
  (lambda () (write-subu8vector '#u8(97 98 99 100) 1 4))))

(test-equal
 '#u8()
 (with-output-to-u8vector
  (lambda () (write-subu8vector '#u8(97 98 99 100) 1 1))))

(test-equal
 '#u8(97 98 99 100)
 (call-with-output-u8vector
  (lambda (port) (write-subu8vector '#u8(97 98 99 100) 0 4 port))))

(test-equal
 '#u8(98 99)
 (call-with-output-u8vector
  (lambda (port) (write-subu8vector '#u8(97 98 99 100) 1 3 port))))

(test-error-tail wrong-number-of-arguments-exception? (write-subu8vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (write-subu8vector '#u8(97 98 99 100)))
(test-error-tail
 wrong-number-of-arguments-exception?
 (write-subu8vector '#u8(97 98 99 100) 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (write-subu8vector '#u8(97 98 99 100) 1 3 (current-output-port) #f))

(test-error-tail type-exception? (write-subu8vector #f 1 3))
(test-error-tail type-exception? (write-subu8vector '#u8(97 98 99 100) #f 3))
(test-error-tail type-exception? (write-subu8vector '#u8(97 98 99 100) 1 #f))
(test-error-tail type-exception? (write-subu8vector '#u8(97 98 99 100) 1 3 #f))

(test-error-tail
 range-exception?
 (write-subu8vector '#u8(97 98 99 100) -1 3 (current-output-port)))
(test-error-tail
 range-exception?
 (write-subu8vector '#u8(97 98 99 100) 0 5 (current-output-port)))
(test-error-tail
 range-exception?
 (write-subu8vector '#u8(97 98 99 100) 3 2 (current-output-port)))
