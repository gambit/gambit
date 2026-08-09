(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception (lambda () (open-udp))))

(define count 0)

(define (timeout-set!)
  (input-port-timeout-set!
   p
   .001
   (lambda ()
     (set! count (+ count 1))
     (if (< count 10) (begin (timeout-set!) #t) #f))))

(define (timeout-reset!) (set! count 0) (timeout-set!))

(timeout-reset!)
(test-equal #!eof (read p))
(test-equal 10 count)

(timeout-reset!)
(test-equal #f (udp-read-u8vector p))
(test-equal 10 count)

(define v (make-u8vector 100))

(timeout-reset!)
(test-equal #f (udp-read-subu8vector v 0 100 p))
(test-equal 10 count)

(input-port-timeout-set! p 1. (lambda () #f))

(thread-start!
 (make-thread (lambda () (thread-sleep! .1) (write '#u8(11 22 33) p))))

(test-equal '#u8(11 22 33) (read p))
