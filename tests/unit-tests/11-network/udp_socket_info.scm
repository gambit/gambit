(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(define ssi1 #f)
(define ssi2 #f)

(set! ssi1 (udp-local-socket-info p))
(parameterize ((current-input-port p)) (set! ssi2 (udp-local-socket-info)))

(test-assert (eq? #t (socket-info? ssi1)))
(test-assert (eq? #t (socket-info? ssi2)))

(test-equal ssi2 ssi1)

(test-equal #f (udp-source-socket-info p))
(parameterize ((current-input-port p))
  (test-equal #f (udp-source-socket-info)))

(write '#u8(11 22 33) p)

(test-equal #f (udp-source-socket-info p))
(parameterize ((current-input-port p))
  (test-equal #f (udp-source-socket-info)))

(test-equal '#u8(11 22 33) (read p))

(define ssi3 (udp-source-socket-info p))

(test-equal ssi1 ssi3)

(write '#u8(44 55 66 77) p)
(test-equal '#u8(44 55 66 77) (read p))

(define ssi4 (udp-source-socket-info p))

(test-eq ssi3 ssi4)

(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-local-socket-info 1 2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (udp-source-socket-info 1 2))

(test-error-tail type-exception? (udp-local-socket-info #f))

(test-error-tail type-exception? (udp-source-socket-info #f))
