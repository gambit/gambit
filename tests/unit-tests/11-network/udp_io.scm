(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(test-eq (void) (write '#u8() p))
(test-eq (void) (write '#u8(11) p))
(test-eq (void) (write '#u8(22 33) p))
(test-eq (void) (write '#u8(44 55 66) p))

(test-equal '#u8() (read p))
(test-equal '#u8(11) (read p))
(test-equal '#u8(22 33) (read p))
(test-equal '#u8(44 55 66) (read p))

(test-eq (void) (udp-write-u8vector '#u8() p))
(test-eq (void) (udp-write-u8vector '#u8(11) p))
(test-eq (void) (udp-write-u8vector '#u8(22 33) p))
(test-eq (void) (udp-write-u8vector '#u8(44 55 66) p))

(test-equal '#u8() (udp-read-u8vector p))
(test-equal '#u8(11) (udp-read-u8vector p))
(test-equal '#u8(22 33) (udp-read-u8vector p))
(test-equal '#u8(44 55 66) (udp-read-u8vector p))

(parameterize ((current-output-port p))
  (test-eq (void) (write '#u8()))
  (test-eq (void) (write '#u8(11)))
  (test-eq (void) (write '#u8(22 33)))
  (test-eq (void) (write '#u8(44 55 66))))

(parameterize ((current-input-port p))
  (test-equal '#u8() (read))
  (test-equal '#u8(11) (read))
  (test-equal '#u8(22 33) (read))
  (test-equal '#u8(44 55 66) (read)))

(parameterize ((current-output-port p))
  (test-eq (void) (udp-write-u8vector '#u8()))
  (test-eq (void) (udp-write-u8vector '#u8(11)))
  (test-eq (void) (udp-write-u8vector '#u8(22 33)))
  (test-eq (void) (udp-write-u8vector '#u8(44 55 66))))

(parameterize ((current-input-port p))
  (test-equal '#u8() (udp-read-u8vector))
  (test-equal '#u8(11) (udp-read-u8vector))
  (test-equal '#u8(22 33) (udp-read-u8vector))
  (test-equal '#u8(44 55 66) (udp-read-u8vector)))

(test-eq (void) (udp-write-subu8vector '#u8(1 2 3 4 5) 1 3 p))
(test-eq (void) (udp-write-subu8vector '#u8(1 2 3 4 5) 0 5 p))

(define buf (make-u8vector 10 0))

(test-approximate 2 (udp-read-subu8vector buf 0 10 p) 1e-12)
(test-equal '#u8(2 3 0 0 0 0 0 0 0 0) buf)

(test-approximate 5 (udp-read-subu8vector buf 0 10 p) 1e-12)
(test-equal '#u8(1 2 3 4 5 0 0 0 0 0) buf)

(test-error-tail wrong-number-of-arguments-exception? (udp-write-u8vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-write-u8vector 1 2 3))

(test-error-tail type-exception? (udp-write-u8vector 1))
(test-error-tail type-exception? (udp-write-u8vector 1 p))
(test-error-tail type-exception? (udp-write-u8vector buf #f))

(test-error-tail wrong-number-of-arguments-exception? (udp-read-u8vector 1 2))

(test-error-tail type-exception? (udp-read-u8vector 1))

(test-error-tail wrong-number-of-arguments-exception? (udp-write-subu8vector))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-write-subu8vector 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-write-subu8vector 1 2))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-write-subu8vector 1 2 3 4 5))

(test-error-tail type-exception? (udp-write-subu8vector 1 0 1))
(test-error-tail type-exception? (udp-write-subu8vector buf #f 1))
(test-error-tail type-exception? (udp-write-subu8vector buf 0 #f))
(test-error-tail type-exception? (udp-write-subu8vector buf 0 1 #f))

(test-error-tail wrong-number-of-arguments-exception? (udp-read-subu8vector))
(test-error-tail wrong-number-of-arguments-exception? (udp-read-subu8vector 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-read-subu8vector 1 2))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-read-subu8vector 1 2 3 4 5))

(test-error-tail type-exception? (udp-read-subu8vector 1 0 1))
(test-error-tail type-exception? (udp-read-subu8vector buf #f 1))
(test-error-tail type-exception? (udp-read-subu8vector buf 0 #f))
(test-error-tail type-exception? (udp-read-subu8vector buf 0 1 #f))

(test-error-tail type-exception? (write #f p))
