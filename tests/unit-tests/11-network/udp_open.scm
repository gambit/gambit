(include "#.scm")

(define p1
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp))))

(check-true (input-port? p1))
(check-true (output-port? p1))

(define p2 (open-udp "*"))

(check-true (input-port? p2))
(check-true (output-port? p2))

(define p3 (open-udp ":0"))

(check-true (input-port? p3))
(check-true (output-port? p3))

(define p4 (open-udp "*:0"))

(check-true (input-port? p4))
(check-true (output-port? p4))

(define p5 (open-udp
            (list local-address: "*"
                  local-port-number: 0)))

(check-true (input-port? p5))
(check-true (output-port? p5))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (open-udp 1 2)))

(check-tail-exn type-exception? (lambda () (open-udp #f)))
(check-tail-exn type-exception? (lambda () (open-udp '(unknown: 0))))
