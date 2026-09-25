(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(define ssi (udp-local-socket-info p))
(test-assert (symbol? (socket-info-family ssi)))
(close-port p)

(test-error-tail type-exception? (socket-info-family 1))
(test-error-tail wrong-number-of-arguments-exception? (socket-info-family))
(test-error-tail wrong-number-of-arguments-exception? (socket-info-family ssi 1))
