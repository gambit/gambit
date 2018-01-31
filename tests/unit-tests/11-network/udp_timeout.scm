(include "#.scm")

(define p
  (exit0-when-unimplemented-operation-os-exception
   (lambda ()
     (open-udp))))

(define count 0)

(define (timeout-set!)
  (input-port-timeout-set!
   p
   0.001
   (lambda ()
     (set! count (+ count 1))
     (if (< count 10)
         (begin
           (timeout-set!)
           #t)
         #f))))

(define (timeout-reset!)
  (set! count 0)
  (timeout-set!))

(timeout-reset!)
(check-equal? (read p) #!eof)
(check-equal? count 10)

(timeout-reset!)
(check-equal? (udp-read-u8vector p) #f)
(check-equal? count 10)

(define v (make-u8vector 100))

(timeout-reset!)
(check-equal? (udp-read-subu8vector v 0 100 p) #f)
(check-equal? count 10)

(input-port-timeout-set! p 1.0 (lambda () #f))

(thread-start!
 (make-thread
  (lambda ()
    (thread-sleep! 0.1)
    (write '#u8(11 22 33) p))))

(check-equal? (read p) '#u8(11 22 33))
