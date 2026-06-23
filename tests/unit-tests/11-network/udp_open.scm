(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(test-assert (eq? #t (input-port? p1)))
(test-assert (eq? #t (output-port? p1)))

(define p2 (open-udp "*"))

(test-assert (eq? #t (input-port? p2)))
(test-assert (eq? #t (output-port? p2)))

(define p3 (open-udp ":0"))

(test-assert (eq? #t (input-port? p3)))
(test-assert (eq? #t (output-port? p3)))

(define p4 (open-udp "*:0"))

(test-assert (eq? #t (input-port? p4)))
(test-assert (eq? #t (output-port? p4)))

(define p5 (open-udp (list local-address: "*" local-port-number: 0)))

(test-assert (eq? #t (input-port? p5)))
(test-assert (eq? #t (output-port? p5)))

(test-error-tail wrong-number-of-arguments-exception? (open-udp 1 2))

(test-error-tail type-exception? (open-udp #f))
(test-error-tail type-exception? (open-udp '(unknown: 0)))
