(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp))))

(define ssi1 (udp-local-socket-info p1))

(define p2
  (open-udp (list address: (socket-info-address ssi1)
                  port-number: (socket-info-port-number ssi1))))

(define ssi2 (udp-local-socket-info p2))

(check-equal? (udp-source-socket-info p1) #f)
(check-equal? (udp-source-socket-info p2) #f)

(write '#u8(11) p1)
(check-equal? (read p1) '#u8(11))

(check-equal? (udp-source-socket-info p1) ssi1)
(check-equal? (udp-source-socket-info p2) #f)

(write '#u8(22) p2)
(check-equal? (read p1) '#u8(22))

(check-equal? (udp-source-socket-info p1) ssi2)
(check-equal? (udp-source-socket-info p2) #f)

(check-equal? (udp-destination-set!
               (socket-info-address ssi2)
               (socket-info-port-number ssi2)
               p2)
              (void))

(write '#u8(33) p2)
(check-equal? (read p2) '#u8(33))

(check-equal? (udp-source-socket-info p1) ssi2)
(check-equal? (udp-source-socket-info p2) ssi2)

(parameterize ((current-output-port p1))
  (check-equal? (udp-destination-set!
                 (socket-info-address ssi1)
                 (socket-info-port-number ssi1))
                (void)))

(write '#u8(44) p1)
(check-equal? (read p1) '#u8(44))

(check-equal? (udp-source-socket-info p1) ssi1)
(check-equal? (udp-source-socket-info p2) ssi2)

(check-equal? (udp-destination-set! #f 1 p1)
              (void))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-destination-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-destination-set! 1)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-destination-set! 1 2 3 4)))

(check-tail-exn os-exception? (lambda () (udp-destination-set!
                                          #t
                                          (socket-info-port-number ssi2)
                                          p2)))

(check-tail-exn type-exception? (lambda () (udp-destination-set!
                                            (socket-info-address ssi2)
                                            #f
                                            p2)))

(check-tail-exn type-exception? (lambda () (udp-destination-set!
                                            (socket-info-address ssi2)
                                            (socket-info-port-number ssi2)
                                            #f)))
