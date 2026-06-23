(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception
   (lambda () (open-udp (list direction: 'input-output)))))

(define p2 (open-udp (list direction: 'output)))

(define p3 (open-udp (list direction: 'input)))

(define p4 (open-udp))

(define ssi3 (udp-local-socket-info p3))

(udp-destination-set!
 (socket-info-address ssi3)
 (socket-info-port-number ssi3)
 p2)

(define buf (make-u8vector 10 0))

(test-eq (void) (write '#u8(11) p1))
(test-eq (void) (udp-write-u8vector '#u8(22) p1))
(test-eq (void) (udp-write-subu8vector '#u8(33) 0 1 p1))
(test-equal '#u8(11) (read p1))
(test-equal '#u8(22) (udp-read-u8vector p1))
(test-equal 1 (udp-read-subu8vector buf 0 10 p1))
(test-equal
 (void)
 (udp-destination-set!
  (socket-info-address ssi3)
  (socket-info-port-number ssi3)
  p1))
(test-assert (eq? #t (socket-info? (udp-local-socket-info p1))))
(test-assert (eq? #t (socket-info? (udp-source-socket-info p1))))

(test-eq (void) (write '#u8(11) p2))
(test-eq (void) (udp-write-u8vector '#u8(22) p2))
(test-eq (void) (udp-write-subu8vector '#u8(33) 0 1 p2))
(test-error-tail type-exception? (read p2))
(test-error-tail type-exception? (udp-read-u8vector p2))
(test-error-tail type-exception? (udp-read-subu8vector buf 0 10 p2))
(test-equal
 (void)
 (udp-destination-set!
  (socket-info-address ssi3)
  (socket-info-port-number ssi3)
  p2))
(test-assert (eq? #t (socket-info? (udp-local-socket-info p2))))
(test-error-tail type-exception? (udp-source-socket-info p2))

(test-error-tail type-exception? (write '#u8(11) p3))
(test-error-tail type-exception? (udp-write-u8vector '#u8(22) p3))
(test-error-tail type-exception? (udp-write-subu8vector '#u8(33) 0 1 p3))
(test-equal '#u8(11) (read p3))
(test-equal '#u8(22) (udp-read-u8vector p3))
(test-equal 1 (udp-read-subu8vector buf 0 10 p3))
(test-error-tail
 type-exception?
 (udp-destination-set!
  (socket-info-address ssi3)
  (socket-info-port-number ssi3)
  p3))
(test-assert (eq? #t (socket-info? (udp-local-socket-info p3))))
(test-assert (eq? #t (socket-info? (udp-source-socket-info p3))))

(test-eq (void) (close-port p4))

(test-error-tail os-exception? (write '#u8(11) p4))
(test-error-tail os-exception? (udp-write-u8vector '#u8(22) p4))
(test-error-tail os-exception? (udp-write-subu8vector '#u8(33) 0 1 p4))
(test-error-tail os-exception? (read p4))
(test-error-tail os-exception? (udp-read-u8vector p4))
(test-error-tail os-exception? (udp-read-subu8vector buf 0 10 p4))
(test-error-tail
 os-exception?
 (udp-destination-set!
  (socket-info-address ssi3)
  (socket-info-port-number ssi3)
  p4))
(test-error-tail os-exception? (udp-local-socket-info p4))
(test-error-tail os-exception? (udp-source-socket-info p4))

(test-eq (void) (close-port p4))
