(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(define ssi1 (udp-local-socket-info p1))

(define p2
  (open-udp
   (list address:
         (socket-info-address ssi1)
         port-number:
         (socket-info-port-number ssi1))))

(define ssi2 (udp-local-socket-info p2))

(test-equal #f (udp-source-socket-info p1))
(test-equal #f (udp-source-socket-info p2))

(write '#u8(11) p1)
(test-equal '#u8(11) (read p1))

(test-equal ssi1 (udp-source-socket-info p1))
(test-equal #f (udp-source-socket-info p2))

(write '#u8(22) p2)
(test-equal '#u8(22) (read p1))

(test-equal ssi2 (udp-source-socket-info p1))
(test-equal #f (udp-source-socket-info p2))

(test-equal
 (void)
 (udp-destination-set!
  (socket-info-address ssi2)
  (socket-info-port-number ssi2)
  p2))

(write '#u8(33) p2)
(test-equal '#u8(33) (read p2))

(test-equal ssi2 (udp-source-socket-info p1))
(test-equal ssi2 (udp-source-socket-info p2))

(parameterize ((current-output-port p1))
  (test-equal
   (void)
   (udp-destination-set!
    (socket-info-address ssi1)
    (socket-info-port-number ssi1))))

(write '#u8(44) p1)
(test-equal '#u8(44) (read p1))

(test-equal ssi1 (udp-source-socket-info p1))
(test-equal ssi2 (udp-source-socket-info p2))

(test-equal (void) (udp-destination-set! #f 1 p1))

(test-error-tail wrong-number-of-arguments-exception? (udp-destination-set!))
(test-error-tail wrong-number-of-arguments-exception? (udp-destination-set! 1))
(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-destination-set! 1 2 3 4))

(test-error-tail
 os-exception?
 (udp-destination-set! #t (socket-info-port-number ssi2) p2))

(test-error-tail
 type-exception?
 (udp-destination-set! (socket-info-address ssi2) #f p2))

(test-error-tail
 type-exception?
 (udp-destination-set!
  (socket-info-address ssi2)
  (socket-info-port-number ssi2)
  #f))
