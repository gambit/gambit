(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp (list direction: 'input-output)))))

(define p2
  (open-udp (list direction: 'output)))

(define p3
  (open-udp (list direction: 'input)))

(define p4
  (open-udp))

(define ssi3 (udp-local-socket-info p3))

(udp-destination-set! (socket-info-address ssi3) (socket-info-port-number ssi3) p2)

(define buf (make-u8vector 10 0))

(check-eq? (write '#u8(11) p1) (void))
(check-eq? (udp-write-u8vector '#u8(22) p1) (void))
(check-eq? (udp-write-subu8vector '#u8(33) 0 1 p1) (void))
(check-equal? (read p1) '#u8(11))
(check-equal? (udp-read-u8vector p1) '#u8(22))
(check-equal? (udp-read-subu8vector buf 0 10 p1) 1)
(check-equal? (udp-destination-set! (socket-info-address ssi3) (socket-info-port-number ssi3) p1) (void))
(check-true (socket-info? (udp-local-socket-info p1)))
(check-true (socket-info? (udp-source-socket-info p1)))

(check-eq? (write '#u8(11) p2) (void))
(check-eq? (udp-write-u8vector '#u8(22) p2) (void))
(check-eq? (udp-write-subu8vector '#u8(33) 0 1 p2) (void))
(check-tail-exn type-exception? (lambda () (read p2)))
(check-tail-exn type-exception? (lambda () (udp-read-u8vector p2)))
(check-tail-exn type-exception? (lambda () (udp-read-subu8vector buf 0 10 p2)))
(check-equal? (udp-destination-set! (socket-info-address ssi3) (socket-info-port-number ssi3) p2) (void))
(check-true (socket-info? (udp-local-socket-info p2)))
(check-tail-exn type-exception? (lambda () (udp-source-socket-info p2)))

(check-tail-exn type-exception? (lambda () (write '#u8(11) p3)))
(check-tail-exn type-exception? (lambda () (udp-write-u8vector '#u8(22) p3)))
(check-tail-exn type-exception? (lambda () (udp-write-subu8vector '#u8(33) 0 1 p3)))
(check-equal? (read p3) '#u8(11))
(check-equal? (udp-read-u8vector p3) '#u8(22))
(check-equal? (udp-read-subu8vector buf 0 10 p3) 1)
(check-tail-exn type-exception? (lambda () (udp-destination-set! (socket-info-address ssi3) (socket-info-port-number ssi3) p3)))
(check-true (socket-info? (udp-local-socket-info p3)))
(check-true (socket-info? (udp-source-socket-info p3)))

(check-eq? (close-port p4) (void))

(check-tail-exn os-exception? (lambda () (write '#u8(11) p4)))
(check-tail-exn os-exception? (lambda () (udp-write-u8vector '#u8(22) p4)))
(check-tail-exn os-exception? (lambda () (udp-write-subu8vector '#u8(33) 0 1 p4)))
(check-tail-exn os-exception? (lambda () (read p4)))
(check-tail-exn os-exception? (lambda () (udp-read-u8vector p4)))
(check-tail-exn os-exception? (lambda () (udp-read-subu8vector buf 0 10 p4)))
(check-tail-exn os-exception? (lambda () (udp-destination-set! (socket-info-address ssi3) (socket-info-port-number ssi3) p4)))
(check-tail-exn os-exception? (lambda () (udp-local-socket-info p4)))
(check-tail-exn os-exception? (lambda () (udp-source-socket-info p4)))

(check-eq? (close-port p4) (void))
