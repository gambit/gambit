(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp))))

(define ssi1 #f)
(define ssi2 #f)

(set! ssi1 (udp-local-socket-info p))
(parameterize ((current-input-port p))
  (set! ssi2 (udp-local-socket-info)))

(check-true (socket-info? ssi1))
(check-true (socket-info? ssi2))

(check-equal? ssi1 ssi2)

(check-equal? (udp-source-socket-info p) #f)
(parameterize ((current-input-port p))
  (check-equal? (udp-source-socket-info) #f))

(write '#u8(11 22 33) p)

(check-equal? (udp-source-socket-info p) #f)
(parameterize ((current-input-port p))
  (check-equal? (udp-source-socket-info) #f))

(check-equal? (read p) '#u8(11 22 33))

(define ssi3 (udp-source-socket-info p))

(check-equal? ssi3 ssi1)

(write '#u8(44 55 66 77) p)
(check-equal? (read p) '#u8(44 55 66 77))

(define ssi4 (udp-source-socket-info p))

(check-eq? ssi4 ssi3)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-local-socket-info 1 2)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (udp-source-socket-info 1 2)))

(check-tail-exn type-exception? (lambda () (udp-local-socket-info #f)))

(check-tail-exn type-exception? (lambda () (udp-source-socket-info #f)))
